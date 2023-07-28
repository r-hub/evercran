
source("lib.R")

init_packages <- function(until = Sys.Date(), force = FALSE) {
  dates <- as.character(seq(as.Date("1999-01-01"), until - 1, by = 1))
  for (date in dates) {
    write_packages(date, force = force)
  }
}

if (is.null(sys.calls())) {
  main()
}
