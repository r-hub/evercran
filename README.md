Run historical R versions on today’s computers
================

- <a href="#tldr" id="toc-tldr">TL;DR</a>
- <a href="#containers-with-multiple-r-versions"
  id="toc-containers-with-multiple-r-versions">Containers with multiple R
  versions</a>
- <a href="#all-containers" id="toc-all-containers">All containers</a>
- <a href="#similar-projects-inspiration"
  id="toc-similar-projects-inspiration">Similar projects, inspiration</a>
- <a href="#thanks" id="toc-thanks">Thanks!</a>
- <a href="#license" id="toc-license">License</a>

<!-- README.md is generated from README.Rmd. Please edit that file -->

## TL;DR

``` sh
docker pull --platform linux/i386 ghcr.io/r-hub/evercran/1.0.0
docker run -ti ghcr.io/r-hub/evercran/1.0.0
```

    R : Copyright 2000, The R Development Core Team
    Version 1.0.0  (February 29, 2000)

    R is free software and comes with ABSOLUTELY NO WARRANTY.
    You are welcome to redistribute it under certain conditions.
    Type    "?license" or "?licence" for distribution details.

    R is a collaborative project with many contributors.
    Type    "?contributors" for a list.

    Type    "demo()" for some demos, "help()" for on-line help, or
            "help.start()" for a HTML browser interface to help.
    Type    "q()" to quit R.

    >

## Containers with multiple R versions

All R versions are installed in `/opt/R/<version>`, so you can run one
with

    /opt/R/<version>/bin/R

For example to run R 0.65.1:

    /opt/R/0.65.1/bin/R

| R versions       | Container                    | OS                    |
|:-----------------|:-----------------------------|:----------------------|
| R 0.49 – R 1.0.0 | `ghcr.io/r-hub/evercran/0.x` | Debian Sarge 3.1 i386 |

## All containers

| R version | Container                      | OS                    |
|:----------|:-------------------------------|:----------------------|
| R 0.49    | ghcr.io/r-hub/evercran/0.49    | Debian Sarge 3.1 i386 |
| R 0.50-a1 | ghcr.io/r-hub/evercran/0.50-a1 | Debian Sarge 3.1 i386 |
| R 0.50-a4 | ghcr.io/r-hub/evercran/0.50-a4 | Debian Sarge 3.1 i386 |
| R 0.60    | ghcr.io/r-hub/evercran/0.60    | Debian Sarge 3.1 i386 |
| R 0.60.1  | ghcr.io/r-hub/evercran/0.60.1  | Debian Sarge 3.1 i386 |
| R 0.61    | ghcr.io/r-hub/evercran/0.61    | Debian Sarge 3.1 i386 |
| R 0.61.1  | ghcr.io/r-hub/evercran/0.61.1  | Debian Sarge 3.1 i386 |
| R 0.61.2  | ghcr.io/r-hub/evercran/0.61.2  | Debian Sarge 3.1 i386 |
| R 0.61.3  | ghcr.io/r-hub/evercran/0.61.3  | Debian Sarge 3.1 i386 |
| R 0.62    | ghcr.io/r-hub/evercran/0.62    | Debian Sarge 3.1 i386 |
| R 0.62.1  | ghcr.io/r-hub/evercran/0.62.1  | Debian Sarge 3.1 i386 |
| R 0.62.2  | ghcr.io/r-hub/evercran/0.62.2  | Debian Sarge 3.1 i386 |
| R 0.62.3  | ghcr.io/r-hub/evercran/0.62.3  | Debian Sarge 3.1 i386 |
| R 0.62.4  | ghcr.io/r-hub/evercran/0.62.4  | Debian Sarge 3.1 i386 |
| R 0.63    | ghcr.io/r-hub/evercran/0.63    | Debian Sarge 3.1 i386 |
| R 0.63.1  | ghcr.io/r-hub/evercran/0.63.1  | Debian Sarge 3.1 i386 |
| R 0.63.2  | ghcr.io/r-hub/evercran/0.63.2  | Debian Sarge 3.1 i386 |
| R 0.63.3  | ghcr.io/r-hub/evercran/0.63.3  | Debian Sarge 3.1 i386 |
| R 0.64.0  | ghcr.io/r-hub/evercran/0.64.0  | Debian Sarge 3.1 i386 |
| R 0.64.1  | ghcr.io/r-hub/evercran/0.64.1  | Debian Sarge 3.1 i386 |
| R 0.64.2  | ghcr.io/r-hub/evercran/0.64.2  | Debian Sarge 3.1 i386 |
| R 0.65.0  | ghcr.io/r-hub/evercran/0.65.0  | Debian Sarge 3.1 i386 |
| R 0.65.1  | ghcr.io/r-hub/evercran/0.65.1  | Debian Sarge 3.1 i386 |
| R 0.90.0  | ghcr.io/r-hub/evercran/0.90.0  | Debian Sarge 3.1 i386 |
| R 0.90.1  | ghcr.io/r-hub/evercran/0.90.1  | Debian Sarge 3.1 i386 |
| R 0.99.0  | ghcr.io/r-hub/evercran/0.99.0  | Debian Sarge 3.1 i386 |
| R 1.0.0   | ghcr.io/r-hub/evercran/1.0.0   | Debian Sarge 3.1 i386 |

## Similar projects, inspiration

- [rcheology](https://github.com/hughjonesd/rcheology) – Data on Base
  Packages for Previous Versions of R
- [rang](https://github.com/chainsawriot/rang) – (Re)constructing R
  computational environments

## Thanks!

- [debian/eol](https://hub.docker.com/r/debian/eol/) – End of Life
  Debian versions (pointing at archive.debian.org)

## License

See <https://www.r-project.org/Licenses/> for the R licenses

The Dockerfiles and tools in this repository are licensed under the MIT
License.

© [R Consortium](https://github.com/rconsortium)
