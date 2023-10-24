source("lib.R")

setup_db_main <- function() {
  if (!wait()) stop("Could not connect to database or database is empty")
  meta <- db$query("SELECT value FROM meta WHERE key = 'last-event-id'")
  if (nrow(meta) == 0) {
    init_db()
    init_db_last()
  }
  update_db()
  init_packages()
}

if (is.null(sys.calls())) {
  setup_db_main()
}
