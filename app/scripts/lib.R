
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

md5 <- function(obj) {
  raw <- serialize(obj, connection = NULL)
  tmp <- tempfile("md5-")
  on.exit(unlink(tmp), add = TRUE)
  writeBin(raw, tmp)
  unname(tools::md5sum(tmp))
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
       AND packages.release_date = dates.release_date
     ORDER BY package, version DESC",
    date = date
  )

  pkgs <- pkgs[, names(metadata_fields)]
  names(pkgs) <- metadata_fields[names(pkgs)]
  checksum <- md5(pkgs)
  ppath0 <- sub("\\.gz$", "", ppath)
  chkpath <- sub("PACKAGES[.]gz$", "MD5", ppath)
  if (file.exists(chkpath)) {
    oldchk <- readLines(chkpath, warn = FALSE)
    if (length(oldchk) == 1 && oldchk == checksum) {
      message(Sys.time(), " Checksum match ", date)
      return(invisible())
    }
  }

  write_dcf(pkgs, ppath0)
  unlink(ppath)
  system2("gzip", c("-9", ppath0))
  writeLines(checksum, chkpath)
  message(Sys.time(), " Wrote out ", date)
  invisible()
}

wait <- function(limit = as.difftime(10, units = "mins")) {
  started <- Sys.time()
  message("Initializing database")
  tryCatch({
    val <- db$query("SELECT value FROM meta WHERE key = 'initialized'")$value
    if (length(val) == 1 && val == "true") return(TRUE)
    if (started + limit > Sys.time()) return(FALSE)
    message("Waiting 5 seconds for database")
    Sys.sleep(5)
  })
}

update_db <- function(force = FALSE) {
  last <- db$query("SELECT value FROM meta WHERE key = 'last-event-id'")$value
  path <- paste0("cran-update-", cli::hash_sha1(last), ".json")
  tmp <- paste0(path, ".tmp")
  on.exit(unlink(tmp))
  if (!file.exists(path)) {
    message("Downloading update")
    url <- paste0(
      "https://crandb.r-pkg.org:2053/cran/_changes?",
      "include_docs=true",
      "&",
      "last-event-id=",
      last
    )
    download.file(url, tmp)
    file.rename(tmp, path)
  }

  message("Parsing update")
  response <- jsonlite::fromJSON(path, simplifyVector = FALSE)
  pkgs <- response$results
  message("Updating ", length(pkgs), " packages.")
  for (pkg in pkgs) {
    if (is.null(pkg$doc$type) && !startsWith(pkg$id, "_")) {
      update_package(pkg, force = force)
    }
  }

  message("Updating last event id.")
  newlast <- response$last_seq
  db$execute(
    "UPDATE meta SET value = ?value WHERE key = 'last-event-id'",
    value = newlast
    )
  unlink(path)
  message("Update complete.")

  invisible(response)
}

init_db <- function(force = FALSE) {
  if (file.exists("cran-full.json.gz")) {
    system2("gzip", c("-d", "cran-full.json.gz"))
  }
  if (!file.exists("cran-full.json")) {
    download.file(
      "https://crandb.r-pkg.org:2053/cran/_all_docs?include_docs=true",
      "cran-full.json.tmp"
    )
    file.rename("cran-full.json.tmp", "cran-full.json")
  }

  pkgs <- jsonlite::fromJSON("cran-full.json", simplifyVector = FALSE)$rows
  for (pkg in pkgs) {
    if (is.null(pkg$doc$type) && !startsWith(pkg$id, "_")) {
      update_package(pkg, force = force)
    }
  }
}

init_db_last <- function() {
  last <- readLines("last-event-id")
  db$transaction({
    db$execute("DELETE FROM meta WHERE key = 'last-event-id'")
    db$execute("INSERT INTO meta VALUES ('last-event-id', ?id)", id = last)
  })
}

needs_update <- function(pkg, id) {
  did <- db$query("SELECT id FROM ids WHERE package = ?pkg", pkg = pkg)
  nrow(did) == 0 || did[1,1] != id
}

format_deps_field <- function(x) {
  if (is.null(x)) return(NA_character_)
  paste0(
    names(x),
    ifelse(unlist(x) == "*", "", paste0(" (", x, ")")),
    collapse = ", "
  )
}

fix_ws <- function(x) {
  sub(":? .*$", "", x)
}

fix_ver <- function(x) {
  gsub("[a-zA-Z]+", "-", x)
}

update_package <- function(pkgdata, force = FALSE) {
  pkgname <- pkgdata$id
  id <- pkgdata$value$rev %||% tail(pkgdata$changes, 1)[[1]]$rev
  if (!is.null(id) && !force && !needs_update(pkgname, id)) return()

  message("Updating package ", pkgname);

  x <- function(field) {
    trimws(sapply(
      pkgdata$doc$versions,
      function(x) x[[field]] %||%  NA_character_
    ))
  }
  xd <- function(field) {
    trimws(sapply(
      pkgdata$do$versions, function(v) format_deps_field(v[[field]])
    ))
  }
  df <- data.frame(
    stringsAsFactors = FALSE,
    package = fix_ws(x("Package")),
    version = fix_ver(fix_ws(x("Version"))),
    depends = xd("Depends"),
    suggests = xd("Suggests"),
    imports = xd("Imports"),
    linkingto = xd("LinkingTo"),
    enhances = xd("Enhances"),
    license = x("License"),
    md5sum = x("MD5sum"),
    needscompilation = x("NeedsCompilation") == "yes",
    license_is_foss = x("License_is_FOSS") == "yes",
    license_restricts_use = x("License_restricts_use") == "yes",
    os_type = x("os_type"),
    priority = x("Priority"),
    archs = x("Archs"),
    path = x("Path"),
    systemrequirements = x("SystemRequirements"),
    release_date = x("date"),
    current = FALSE
  )

  if (!isTRUE(pkgdata$doc$archived)) df[nrow(df), "current"] <- TRUE

  db$transaction({
    db$execute("DELETE FROM packages WHERE package = ?pkg", pkg = pkgname)
    db$execute("DELETE FROM ids WHERE package = ?pkg", pkg = pkgname)
    db$append_table("packages", df)
    db$execute("INSERT INTO ids VALUES (?pkg,?id)", pkg = pkgname, id = id)
  })
}

init_packages <- function(from = as.Date("1999-01-01"),
                          until = Sys.Date(),
                          force = FALSE) {
  dates <- as.character(seq(as.Date(from), as.Date(until) - 1, by = 1))
  for (date in dates) {
    write_packages(date, force = force)
  }
}
