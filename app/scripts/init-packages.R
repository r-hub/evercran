
source("lib.R")

init_package_main <- function() {
  init_packages()
}

if (is.null(sys.calls())) {
  init_packages_main()
}
