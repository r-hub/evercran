
`%||%` <- function(l, r) if (is.null(l)) r else l

db <- local({
  con <- NULL
  db_connect <- function() {
    host <- Sys.getenv("PG_HOST")
    user <- "postgres"
    pass <- readLines(Sys.getenv("PG_PASS_FILE"))
    if (is.null(con) || ! DBI::dbIsValid(con)) {
      con <<- DBI::dbConnect(
        RPostgres::Postgres(),
        host = host,
        user = user,
        pass = pass
      )
    }
  }

  db_query <- function(q, ...) {
    db_connect()
    sq <- DBI::sqlInterpolate(con, q, ...)
    DBI::dbGetQuery(con, sq)
  }

  db_execute <- function(q, ...) {
    db_connect()
    sq <- DBI::sqlInterpolate(con, q, ...)
    DBI::dbExecute(con, sq);
  }

  db_transaction <- function(...) {
    db_connect()
    DBI::dbWithTransaction(con, ...)
  }

  db_append_table <- function(name, value) {
    db_connect()
    DBI::dbAppendTable(con, name, value)
  }

  list(
    append_table = db_append_table,
    execute      = db_execute,
    query        = db_query,
    transaction  = db_transaction
  )
})

metadata_fields <- c(
  "package" = "Package",
  "version" = "Version",
  "depends" = "Depends",
  "suggests" = "Suggests",
  "imports" = "Imports",
  "linkingto" = "LinkingTo",
  "enhances" = "Enhances",
  "license" = "License",
  "md5sum" = "MD5sum",
  "needscompilation" = "NeedsCompilation",
  "license_is_foss" = "License_is_FOSS",
  "license_restricts_use" = "License_restricts_use",
  "os_type" = "OS_type",
  "priority" = "Priority",
  "archs" = "Archs",
  "path" = "Path",
  "systemrequirements" = "SystemRequirements"
)

# We need this because write.dcf() is too slow
# TODO: wrap long lines

write_dcf <- function(tab, file) {
  fields <- mapply(names(tab), tab, FUN = function(name, val) {
    val <- gsub("\n", " ", val, fixed = TRUE)
    val <- gsub("<U+000a>", " ", val, fixed = TRUE)
    ifelse (is.na(val), "", paste0(name, ": ", val, "\n"))
  })
  recs <- apply(fields, 1, paste, collapse = "")
  dcf <- paste(recs, collapse = "\n")
  writeBin(charToRaw(dcf), file)
}

write_packages <- function(date, force = FALSE, path = "/packages") {
  if (!grepl("[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]", date)) {
    stop("`date` must be a date string in 'YYYY-MM-DD' format")
  }
  year <- substr(date, 1, 4)
  month <- substr(date, 6, 7)
  day <- substr(date, 9, 10)
  ppath <- file.path(path, year, month, day, "src/contrib/PACKAGES.gz")
  if (file.exists(ppath) && !force) {
    message(date, " was already done")
    return()
  }
  dir.create(dirname(ppath), showWarnings = FALSE, recursive = TRUE)

  pkgs <- db$query(
    "SELECT packages.* FROM packages,
            (SELECT package, MAX(release_date) AS release_date
             FROM packages WHERE release_date < ?date
             GROUP BY package) AS dates
     WHERE packages.package = dates.package
       AND packages.release_date = dates.release_date",
    date = date
  )

  pkgs <- pkgs[, names(metadata_fields)]
  names(pkgs) <- metadata_fields[names(pkgs)]
  ppath0 <- sub("\\.gz$", "", ppath)
  write_dcf(pkgs, ppath0)
  unlink(ppath)
  system2("gzip", c("-9", ppath0))
  message(Sys.time(), " Wrote out ", date)
  invisible()
}
