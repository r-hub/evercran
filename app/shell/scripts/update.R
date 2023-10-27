source("lib.R")

update_main <- function() {
  update_db()
  init_packages(force = TRUE)
}

if (is.null(sys.calls())) {
  update_main()
}
