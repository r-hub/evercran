source("lib.R")

update_db_main <- function() {
  update_db()
}

if (is.null(sys.calls())) {
  update_db_main()
}
