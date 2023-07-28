
# apk add postgresql13-dev
# installr -d jsonlite RPostgres
# apk add postgresql13-client

source("lib.R")

main <- function() {
  if (file.exists("cran-full.json.gz")) {
    system2("gzip", c("-d", "cran-full.json.gz"))
  }
  if (!file.exists("cran-full.json")) {
    download.file(
      "https://crandb.r-pkg.org:2053/cran/_all_docs?include_docs=true",
      "cran-full.json.tmp"
    )
    file.rename("cran-full.json.tml", "cran-full.json")
  }

  pkgs <- jsonlite::fromJSON("cran-full.json", simplifyVector = FALSE)$rows
  for (pkg in pkgs) {
    if (is.null(pkg$doc$type) && !startsWith(pkg$id, "_")) {
      update_package(pkg)
    }
  }
}

needs_update <- function(pkg, id) {
  did <- db$query("SELECT id FROM ids WHERE package = ?pkg", pkg = pkg)
  nrow(did) == 0 || did[1,1] != id
}

format_deps_field <- function(x) {
  if (is.null(x)) return(NA_character_)
  paste0(names(x), ifelse(unlist(x) == "*", "", paste0(" ", x)), collapse = ", ")
}

update_package <- function(pkgdata) {
  pkgname <- pkgdata$id
  id <- pkgdata$value$rev
  if (!needs_update(pkgname, id)) return()

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
    package = x("Package"),
    version = x("Version"),
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

if (is.null(sys.calls())) {
  main()
}
