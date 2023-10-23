source("lib.R")

update_main <- function() {
  response <- update_db()
  if (length(response$results) > 0) {
    init_packages(force = TRUE)
  }
}

if (is.null(sys.calls())) {
  update_main()
}
