
source("lib.R")

init_db_main <- function() {
  init_db()
  init_db_last()
}

if (is.null(sys.calls())) {
  init_db_main()
}
