Run historical R versions on today’s computers
================

- <a href="#tldr" id="toc-tldr">TL;DR</a>
- <a href="#r-049--r-191" id="toc-r-049--r-191">R 0.49 – R 1.9.1</a>
- <a href="#containers-with-multiple-r-versions"
  id="toc-containers-with-multiple-r-versions">Containers with multiple R
  versions</a>
- <a href="#list-of-all-containers" id="toc-list-of-all-containers">List
  of all containers</a>
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

## R 0.49 – R 1.9.1

``` sh
docker pull --platform linux/i386 ghcr.io/r-hub/evercran/<version>
docker run -ti ghcr.io/r-hub/evercran/<version>
```

These containers use Debian 3.1 (Sarge). Notes:

- While `wget` and `curl` have HTTPS support, in practice HTTPS does not
  work because of certificate errors.

- You can use the HTTP (not HTTPS!) PPA at
  <https://ppa.r-pkg.org/evercran/> to install more R versions:

  ``` sh
  echo 'deb http://ppa.r-pkg.org/evercran sarge main' \
    >> /etc/apt/sources.list
  apt-get update -y
  apt-get install -y r-1.0.0
  ```

## Containers with multiple R versions

All R versions are installed in `/opt/R/<version>`, so you can run one
with

    /opt/R/<version>/bin/R

For example to run R 0.65.1:

    /opt/R/0.65.1/bin/R

| R versions        | Container                    | OS                    |
|:------------------|:-----------------------------|:----------------------|
| R 0.49 – R 1.0.0  | `ghcr.io/r-hub/evercran/0.x` | Debian Sarge 3.1 i386 |
| R 1.0.0 – R 1.9.1 | `ghcr.io/r-hub/evercran/1.x` | Debian Sarge 3.1 i386 |

## List of all containers

| R version | Container                        | Platform     | OS                    |
|:----------|:---------------------------------|:-------------|:----------------------|
| R 0.49    | `ghcr.io/r-hub/evercran/0.49`    | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.50-a1 | `ghcr.io/r-hub/evercran/0.50-a1` | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.50-a4 | `ghcr.io/r-hub/evercran/0.50-a4` | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.60    | `ghcr.io/r-hub/evercran/0.60`    | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.60.1  | `ghcr.io/r-hub/evercran/0.60.1`  | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.61    | `ghcr.io/r-hub/evercran/0.61`    | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.61.1  | `ghcr.io/r-hub/evercran/0.61.1`  | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.61.2  | `ghcr.io/r-hub/evercran/0.61.2`  | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.61.3  | `ghcr.io/r-hub/evercran/0.61.3`  | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.62    | `ghcr.io/r-hub/evercran/0.62`    | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.62.1  | `ghcr.io/r-hub/evercran/0.62.1`  | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.62.2  | `ghcr.io/r-hub/evercran/0.62.2`  | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.62.3  | `ghcr.io/r-hub/evercran/0.62.3`  | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.62.4  | `ghcr.io/r-hub/evercran/0.62.4`  | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.63    | `ghcr.io/r-hub/evercran/0.63`    | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.63.1  | `ghcr.io/r-hub/evercran/0.63.1`  | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.63.2  | `ghcr.io/r-hub/evercran/0.63.2`  | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.63.3  | `ghcr.io/r-hub/evercran/0.63.3`  | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.64.0  | `ghcr.io/r-hub/evercran/0.64.0`  | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.64.1  | `ghcr.io/r-hub/evercran/0.64.1`  | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.64.2  | `ghcr.io/r-hub/evercran/0.64.2`  | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.65.0  | `ghcr.io/r-hub/evercran/0.65.0`  | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.65.1  | `ghcr.io/r-hub/evercran/0.65.1`  | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.90.0  | `ghcr.io/r-hub/evercran/0.90.0`  | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.90.1  | `ghcr.io/r-hub/evercran/0.90.1`  | `linux/i386` | Debian Sarge 3.1 i386 |
| R 0.99.0  | `ghcr.io/r-hub/evercran/0.99.0`  | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.0.0   | `ghcr.io/r-hub/evercran/1.0.0`   | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.0.1   | `ghcr.io/r-hub/evercran/1.0.1`   | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.1.0   | `ghcr.io/r-hub/evercran/1.1.0`   | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.1.1   | `ghcr.io/r-hub/evercran/1.1.1`   | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.2.0   | `ghcr.io/r-hub/evercran/1.2.0`   | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.2.1   | `ghcr.io/r-hub/evercran/1.2.1`   | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.2.2   | `ghcr.io/r-hub/evercran/1.2.2`   | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.2.3   | `ghcr.io/r-hub/evercran/1.2.3`   | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.3.0   | `ghcr.io/r-hub/evercran/1.3.0`   | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.3.1   | `ghcr.io/r-hub/evercran/1.3.1`   | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.4.0   | `ghcr.io/r-hub/evercran/1.4.0`   | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.4.1   | `ghcr.io/r-hub/evercran/1.4.1`   | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.5.0   | `ghcr.io/r-hub/evercran/1.5.0`   | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.5.1   | `ghcr.io/r-hub/evercran/1.5.1`   | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.6.0   | `ghcr.io/r-hub/evercran/1.6.0`   | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.6.1   | `ghcr.io/r-hub/evercran/1.6.1`   | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.6.2   | `ghcr.io/r-hub/evercran/1.6.2`   | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.7.0   | `ghcr.io/r-hub/evercran/1.7.0`   | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.7.1   | `ghcr.io/r-hub/evercran/1.7.1`   | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.8.0   | `ghcr.io/r-hub/evercran/1.8.0`   | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.8.1   | `ghcr.io/r-hub/evercran/1.8.1`   | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.9.0   | `ghcr.io/r-hub/evercran/1.9.0`   | `linux/i386` | Debian Sarge 3.1 i386 |
| R 1.9.1   | `ghcr.io/r-hub/evercran/1.9.1`   | `linux/i386` | Debian Sarge 3.1 i386 |

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
