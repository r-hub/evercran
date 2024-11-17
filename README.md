Run historical R versions on today’s computers
================

- [Experimental!](#experimental)
- [TL;DR](#tldr)
- [The evercran CRAN snapshots](#the-evercran-cran-snapshots)
- [Interactive R shell on GitHub
  Actions](#interactive-r-shell-on-github-actions)
- [R 0.0 (alpha-test) – R 2.5.1](#r-00-alpha-test--r-251)
- [R 2.6.0 – R 2.8.1](#r-260--r-281)
- [R 2.9.0 – R 2.12.2](#r-290--r-2122)
- [R 2.13.0 – R 2.15.3](#r-2130--r-2153)
- [R 3.0.0 – R 4.4.2](#r-300--r-442)
- [Containers with multiple R
  versions](#containers-with-multiple-r-versions)
- [List of all containers](#list-of-all-containers)
- [Frequently asked questions](#frequently-asked-questions)
- [Similar projects, inspiration](#similar-projects-inspiration)
- [Thanks!](#thanks)
- [License](#license)

<!-- README.md is generated from README.Rmd. Please edit that file -->

## Experimental!

Note that these containers are currently experimental!

Found a bug? [Please let us
know!](https://github.com/r-hub/evercran/issues/new) Thanks!

## TL;DR

``` sh
docker pull ghcr.io/r-hub/evercran/1.0.0
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

## The evercran CRAN snapshots

The evercran project has daily CRAN snapshots, starting from the very
beginning up to today. The URLs are of the form

    http://evercran.r-pkg.org/YYYY/MM/DD
    https://evercran.r-pkg.org/YYYY/MM/DD

and they start at 1999/01/01.

Package downloads are redirected to CRAN, so you will need an R download
method that follows redirection.

All the evercran containers (from R 0.65.1) in this repository are
already set up to an appropriate evercran snapshot: they use the date of
the *next* R release. (Except for the container of the latest R release,
of course, that uses a regular CRAN mirror instead of a snapshot.)

To use an evercran snapshot on a different R installation, this should
work on all R versions, as of today:

    options(CRAN = "http://evercran.r-pkg.org/2010/10/10")
    options(repos = c(CRAN = "http://evercran.r-pkg.org/2010/10/10"))
    options(download.file.method = "wget")

Modify the URLs to use the snapshot date you’d like. Add this to the
`~/.Rprofile` file. You’ll also need to install `wget` for the downloads
to work. You can use a https URL if your `wget` installation supports
https.

## Interactive R shell on GitHub Actions

You can also run any R version interactively on GitHub Actions, using
the
[`r-hub/evercran-shell`](https://github.com/r-hub/evercran-shell#readme)
repository. You only need an SSH client for this. See
[`r-hub/evercran-shell`](https://github.com/r-hub/evercran-shell#readme)
for the details.

## R 0.0 (alpha-test) – R 2.5.1

``` sh
docker pull ghcr.io/r-hub/evercran/<version>
docker run -ti ghcr.io/r-hub/evercran/<version>
```

These containers use Debian 3.1 (Sarge). Notes:

- All containers use the `linux/i386` architecture.

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

- The Debian R packages are also available as GitHub Releases, in the
  <https://github.com/r-hub/R> repository, e.g.:
  <https://github.com/r-hub/R/releases/tag/v1.0.0> (But you cannot
  directly download these from the containers, because of the broken
  HTTPS. Use the PPA to download them.)

## R 2.6.0 – R 2.8.1

``` sh
docker pull ghcr.io/r-hub/evercran/<version>
docker run -ti ghcr.io/r-hub/evercran/<version>
```

These containers use Debian 4.0 (Etch). Notes:

- All containers use the `linux/i386` architecture.

- While `wget` and `curl` have HTTPS support, in practice HTTPS does not
  work well, because they use TLS v1, which is not supported by many
  servers.

- You can use the HTTP (not HTTPS!) PPA at
  <https://ppa.r-pkg.org/evercran/> to install more R versions:

  ``` sh
  echo 'deb http://ppa.r-pkg.org/evercran etch main' \
    >> /etc/apt/sources.list
  curl -L http://ppa.r-pkg.org/rhub.gpg.key | apt-key add -
  apt-get update -y
  apt-get install -y r-2.6.0
  ```

- The Debian R packages are also available as GitHub Releases, in the
  <https://github.com/r-hub/R> repository, e.g.:
  <https://github.com/r-hub/R/releases/tag/v2.6.0> (But you cannot
  directly download these from the containers, because of the broken
  HTTPS. Use the PPA to download them.)

## R 2.9.0 – R 2.12.2

``` sh
docker pull ghcr.io/r-hub/evercran/<version>
docker run -ti ghcr.io/r-hub/evercran/<version>
```

These containers use Debian 5.0.10 (Lenny). Notes:

- All containers use the `linux/i386` architecture.

- While `wget` and `curl` have HTTPS support, in practice HTTPS does not
  work well, because they use TLS v1, which is not supported by many
  servers.

- You can use the HTTP (not HTTPS!) PPA at
  <https://ppa.r-pkg.org/evercran/> to install more R versions:

  ``` sh
  echo 'deb http://ppa.r-pkg.org/evercran lenny main' \
    >> /etc/apt/sources.list
  curl -L http://ppa.r-pkg.org/rhub.gpg.key | apt-key add -
  apt-get update -y
  apt-get install -y r-2.9.0
  ```

- The Debian R packages are also available as GitHub Releases, in the
  <https://github.com/r-hub/R> repository, e.g.:
  <https://github.com/r-hub/R/releases/tag/v2.9.0> (But you cannot
  directly download these from the containers, because of the broken
  HTTPS. Use the PPA to download them.)

## R 2.13.0 – R 2.15.3

``` sh
docker pull ghcr.io/r-hub/evercran/<version>
docker run -ti ghcr.io/r-hub/evercran/<version>
```

These containers use Debian 6.0.10 (Squeeze). Notes:

- All containers use the `linux/i386` architecture.

- While `wget` and `curl` have HTTPS support, in practice HTTPS does not
  work well, because they use TLS v1, which is not supported by many
  servers.

- You can use the HTTP (not HTTPS!) PPA at
  <https://ppa.r-pkg.org/evercran/> to install more R versions:

  ``` sh
  echo 'deb http://ppa.r-pkg.org/evercran squeeze main' \
    >> /etc/apt/sources.list
  curl -L http://ppa.r-pkg.org/rhub.gpg.key | apt-key add -
  apt-get update -y
  apt-get install -y r-2.13.0
  ```

- The Debian R packages are also available as GitHub Releases, in the
  <https://github.com/r-hub/R> repository, e.g.:
  <https://github.com/r-hub/R/releases/tag/v2.13.0> (But you cannot
  directly download these from the containers, because of the broken
  HTTPS. Use the PPA to download them.)

## R 3.0.0 – R 4.4.2

``` sh
docker pull ghcr.io/r-hub/evercran/<version>
docker run -ti ghcr.io/r-hub/evercran/<version>
```

These containers use Debian 12.1 (Bookworm). Notes:

- All containers are available with `linux/amd64` and `linux/arm64`
  architectures.

- The amd64 Debian packages are available from
  <https://github.com/rstudio/r-builds>.

- The arm64 Debian packages are available from the GitHub Releases at
  the <https://github.com/r-hub/R> repository E.g.
  <https://github.com/r-hub/R/releases/tag/v4.3.1>.

- To install additional R versions (or to install in a plain `debian:12`
  container), download it with `wget` or `curl`, and install it with
  `apt install ./<filename>`. E.g.:

  ``` sh
  apt-get update
  apt-get install -y curl
  curl -LO https://github.com/r-hub/R/releases/download/v4.3.1/r-rstudio-debian-12-4.3.1_1_arm64.deb
  apt install -y ./r-rstudio-debian-12-4.3.1_1_arm64.deb
  /opt/R/4.3.1/bin/R
  ```

## Containers with multiple R versions

For convenience we have containers that include many R versions
installed.

All R versions are installed in `/opt/R/<version>`, so you can run one
with

    /opt/R/<version>/bin/R

For example to run R 0.65.1:

    /opt/R/0.65.1/bin/R

| R versions                            | Container                    | OS                      |
|:--------------------------------------|:-----------------------------|:------------------------|
| R 0.0 (alpha-test) – R 0.16.1 (alpha) | `ghcr.io/r-hub/evercran/pre` | Debian Sarge 3.1 i386   |
| R 0.49 – R 1.0.0                      | `ghcr.io/r-hub/evercran/0.x` | Debian Sarge 3.1 i386   |
| R 1.0.0 – R 1.9.1                     | `ghcr.io/r-hub/evercran/1.x` | Debian Sarge 3.1 i386   |
| R 2.0.0 – R 2.15.3                    | `ghcr.io/r-hub/evercran/2.x` | Debian Wheezy 7.11 i386 |

## List of all containers

| R version          | Container                        | Platform                     | OS                    |
|:-------------------|:---------------------------------|:-----------------------------|:----------------------|
| R 0.0 (alpha-test) | `ghcr.io/r-hub/evercran/0.0`     | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.1 (alpha)      | `ghcr.io/r-hub/evercran/0.1`     | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.2 (alpha)      | `ghcr.io/r-hub/evercran/0.2`     | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.3 (alpha)      | `ghcr.io/r-hub/evercran/0.3`     | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.4 (alpha)      | `ghcr.io/r-hub/evercran/0.4`     | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.5 (alpha)      | `ghcr.io/r-hub/evercran/0.5`     | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.6 (alpha)      | `ghcr.io/r-hub/evercran/0.6`     | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.7 (alpha)      | `ghcr.io/r-hub/evercran/0.7`     | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.8 (alpha)      | `ghcr.io/r-hub/evercran/0.8`     | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.9 (alpha)      | `ghcr.io/r-hub/evercran/0.9`     | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.10 (alpha)     | `ghcr.io/r-hub/evercran/0.10`    | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.11 (alpha)     | `ghcr.io/r-hub/evercran/0.11`    | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.12 (alpha)     | `ghcr.io/r-hub/evercran/0.12`    | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.13 (alpha)     | `ghcr.io/r-hub/evercran/0.13`    | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.14 (alpha)     | `ghcr.io/r-hub/evercran/0.14`    | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.15 (alpha)     | `ghcr.io/r-hub/evercran/0.15`    | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.16 (alpha)     | `ghcr.io/r-hub/evercran/0.16`    | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.16.1 (alpha)   | `ghcr.io/r-hub/evercran/0.16.1`  | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.49             | `ghcr.io/r-hub/evercran/0.49`    | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.50-a1          | `ghcr.io/r-hub/evercran/0.50-a1` | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.50-a4          | `ghcr.io/r-hub/evercran/0.50-a4` | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.60             | `ghcr.io/r-hub/evercran/0.60`    | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.60.1           | `ghcr.io/r-hub/evercran/0.60.1`  | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.61             | `ghcr.io/r-hub/evercran/0.61`    | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.61.1           | `ghcr.io/r-hub/evercran/0.61.1`  | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.61.2           | `ghcr.io/r-hub/evercran/0.61.2`  | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.61.3           | `ghcr.io/r-hub/evercran/0.61.3`  | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.62             | `ghcr.io/r-hub/evercran/0.62`    | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.62.1           | `ghcr.io/r-hub/evercran/0.62.1`  | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.62.2           | `ghcr.io/r-hub/evercran/0.62.2`  | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.62.3           | `ghcr.io/r-hub/evercran/0.62.3`  | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.62.4           | `ghcr.io/r-hub/evercran/0.62.4`  | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.63             | `ghcr.io/r-hub/evercran/0.63`    | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.63.1           | `ghcr.io/r-hub/evercran/0.63.1`  | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.63.2           | `ghcr.io/r-hub/evercran/0.63.2`  | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.63.3           | `ghcr.io/r-hub/evercran/0.63.3`  | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.64.0           | `ghcr.io/r-hub/evercran/0.64.0`  | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.64.1           | `ghcr.io/r-hub/evercran/0.64.1`  | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.64.2           | `ghcr.io/r-hub/evercran/0.64.2`  | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.65.0           | `ghcr.io/r-hub/evercran/0.65.0`  | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.65.1           | `ghcr.io/r-hub/evercran/0.65.1`  | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.90.0           | `ghcr.io/r-hub/evercran/0.90.0`  | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.90.1           | `ghcr.io/r-hub/evercran/0.90.1`  | `linux/i386`                 | Debian Sarge 3.1      |
| R 0.99.0           | `ghcr.io/r-hub/evercran/0.99.0`  | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.0.0            | `ghcr.io/r-hub/evercran/1.0.0`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.0.1            | `ghcr.io/r-hub/evercran/1.0.1`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.1.0            | `ghcr.io/r-hub/evercran/1.1.0`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.1.1            | `ghcr.io/r-hub/evercran/1.1.1`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.2.0            | `ghcr.io/r-hub/evercran/1.2.0`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.2.1            | `ghcr.io/r-hub/evercran/1.2.1`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.2.2            | `ghcr.io/r-hub/evercran/1.2.2`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.2.3            | `ghcr.io/r-hub/evercran/1.2.3`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.3.0            | `ghcr.io/r-hub/evercran/1.3.0`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.3.1            | `ghcr.io/r-hub/evercran/1.3.1`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.4.0            | `ghcr.io/r-hub/evercran/1.4.0`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.4.1            | `ghcr.io/r-hub/evercran/1.4.1`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.5.0            | `ghcr.io/r-hub/evercran/1.5.0`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.5.1            | `ghcr.io/r-hub/evercran/1.5.1`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.6.0            | `ghcr.io/r-hub/evercran/1.6.0`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.6.1            | `ghcr.io/r-hub/evercran/1.6.1`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.6.2            | `ghcr.io/r-hub/evercran/1.6.2`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.7.0            | `ghcr.io/r-hub/evercran/1.7.0`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.7.1            | `ghcr.io/r-hub/evercran/1.7.1`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.8.0            | `ghcr.io/r-hub/evercran/1.8.0`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.8.1            | `ghcr.io/r-hub/evercran/1.8.1`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.9.0            | `ghcr.io/r-hub/evercran/1.9.0`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 1.9.1            | `ghcr.io/r-hub/evercran/1.9.1`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 2.0.0            | `ghcr.io/r-hub/evercran/2.0.0`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 2.0.1            | `ghcr.io/r-hub/evercran/2.0.1`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 2.1.0            | `ghcr.io/r-hub/evercran/2.1.0`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 2.1.1            | `ghcr.io/r-hub/evercran/2.1.1`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 2.2.0            | `ghcr.io/r-hub/evercran/2.2.0`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 2.2.1            | `ghcr.io/r-hub/evercran/2.2.1`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 2.3.0            | `ghcr.io/r-hub/evercran/2.3.0`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 2.3.1            | `ghcr.io/r-hub/evercran/2.3.1`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 2.4.0            | `ghcr.io/r-hub/evercran/2.4.0`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 2.4.1            | `ghcr.io/r-hub/evercran/2.4.1`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 2.5.0            | `ghcr.io/r-hub/evercran/2.5.0`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 2.5.1            | `ghcr.io/r-hub/evercran/2.5.1`   | `linux/i386`                 | Debian Sarge 3.1      |
| R 2.6.0            | `ghcr.io/r-hub/evercran/2.6.0`   | `linux/i386`                 | Debian Etch 4.0r9     |
| R 2.6.1            | `ghcr.io/r-hub/evercran/2.6.1`   | `linux/i386`                 | Debian Etch 4.0r9     |
| R 2.6.2            | `ghcr.io/r-hub/evercran/2.6.2`   | `linux/i386`                 | Debian Etch 4.0r9     |
| R 2.7.0            | `ghcr.io/r-hub/evercran/2.7.0`   | `linux/i386`                 | Debian Etch 4.0r9     |
| R 2.7.1            | `ghcr.io/r-hub/evercran/2.7.1`   | `linux/i386`                 | Debian Etch 4.0r9     |
| R 2.7.2            | `ghcr.io/r-hub/evercran/2.7.2`   | `linux/i386`                 | Debian Etch 4.0r9     |
| R 2.8.0            | `ghcr.io/r-hub/evercran/2.8.0`   | `linux/i386`                 | Debian Etch 4.0r9     |
| R 2.8.1            | `ghcr.io/r-hub/evercran/2.8.1`   | `linux/i386`                 | Debian Etch 4.0r9     |
| R 2.9.0            | `ghcr.io/r-hub/evercran/2.9.0`   | `linux/i386`                 | Debian Lenny 5.0.10   |
| R 2.9.1            | `ghcr.io/r-hub/evercran/2.9.1`   | `linux/i386`                 | Debian Lenny 5.0.10   |
| R 2.9.2            | `ghcr.io/r-hub/evercran/2.9.2`   | `linux/i386`                 | Debian Lenny 5.0.10   |
| R 2.10.0           | `ghcr.io/r-hub/evercran/2.10.0`  | `linux/i386`                 | Debian Lenny 5.0.10   |
| R 2.10.1           | `ghcr.io/r-hub/evercran/2.10.1`  | `linux/i386`                 | Debian Lenny 5.0.10   |
| R 2.11.0           | `ghcr.io/r-hub/evercran/2.11.0`  | `linux/i386`                 | Debian Lenny 5.0.10   |
| R 2.11.1           | `ghcr.io/r-hub/evercran/2.11.1`  | `linux/i386`                 | Debian Lenny 5.0.10   |
| R 2.12.0           | `ghcr.io/r-hub/evercran/2.12.0`  | `linux/i386`                 | Debian Lenny 5.0.10   |
| R 2.12.1           | `ghcr.io/r-hub/evercran/2.12.1`  | `linux/i386`                 | Debian Lenny 5.0.10   |
| R 2.12.2           | `ghcr.io/r-hub/evercran/2.12.2`  | `linux/i386`                 | Debian Lenny 5.0.10   |
| R 2.13.0           | `ghcr.io/r-hub/evercran/2.13.0`  | `linux/i386`                 | Debian Squeeze 6.0.10 |
| R 2.13.1           | `ghcr.io/r-hub/evercran/2.13.1`  | `linux/i386`                 | Debian Squeeze 6.0.10 |
| R 2.13.2           | `ghcr.io/r-hub/evercran/2.13.2`  | `linux/i386`                 | Debian Squeeze 6.0.10 |
| R 2.14.0           | `ghcr.io/r-hub/evercran/2.14.0`  | `linux/i386`                 | Debian Squeeze 6.0.10 |
| R 2.14.1           | `ghcr.io/r-hub/evercran/2.14.1`  | `linux/i386`                 | Debian Squeeze 6.0.10 |
| R 2.14.2           | `ghcr.io/r-hub/evercran/2.14.2`  | `linux/i386`                 | Debian Squeeze 6.0.10 |
| R 2.15.0           | `ghcr.io/r-hub/evercran/2.15.0`  | `linux/i386`                 | Debian Squeeze 6.0.10 |
| R 2.15.1           | `ghcr.io/r-hub/evercran/2.15.1`  | `linux/i386`                 | Debian Squeeze 6.0.10 |
| R 2.15.2           | `ghcr.io/r-hub/evercran/2.15.2`  | `linux/i386`                 | Debian Squeeze 6.0.10 |
| R 2.15.3           | `ghcr.io/r-hub/evercran/2.15.3`  | `linux/i386`                 | Debian Squeeze 6.0.10 |
| R 3.0.0            | `ghcr.io/r-hub/evercran/3.0.0`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.0.1            | `ghcr.io/r-hub/evercran/3.0.1`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.0.2            | `ghcr.io/r-hub/evercran/3.0.2`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.0.3            | `ghcr.io/r-hub/evercran/3.0.3`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.1.0            | `ghcr.io/r-hub/evercran/3.1.0`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.1.1            | `ghcr.io/r-hub/evercran/3.1.1`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.1.2            | `ghcr.io/r-hub/evercran/3.1.2`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.1.3            | `ghcr.io/r-hub/evercran/3.1.3`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.2.0            | `ghcr.io/r-hub/evercran/3.2.0`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.2.1            | `ghcr.io/r-hub/evercran/3.2.1`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.2.2            | `ghcr.io/r-hub/evercran/3.2.2`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.2.3            | `ghcr.io/r-hub/evercran/3.2.3`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.2.4            | `ghcr.io/r-hub/evercran/3.2.4`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.2.5            | `ghcr.io/r-hub/evercran/3.2.5`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.3.0            | `ghcr.io/r-hub/evercran/3.3.0`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.3.1            | `ghcr.io/r-hub/evercran/3.3.1`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.3.2            | `ghcr.io/r-hub/evercran/3.3.2`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.3.3            | `ghcr.io/r-hub/evercran/3.3.3`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.4.0            | `ghcr.io/r-hub/evercran/3.4.0`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.4.1            | `ghcr.io/r-hub/evercran/3.4.1`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.4.2            | `ghcr.io/r-hub/evercran/3.4.2`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.4.3            | `ghcr.io/r-hub/evercran/3.4.3`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.4.4            | `ghcr.io/r-hub/evercran/3.4.4`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.5.0            | `ghcr.io/r-hub/evercran/3.5.0`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.5.1            | `ghcr.io/r-hub/evercran/3.5.1`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.5.2            | `ghcr.io/r-hub/evercran/3.5.2`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.5.3            | `ghcr.io/r-hub/evercran/3.5.3`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.6.0            | `ghcr.io/r-hub/evercran/3.6.0`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.6.1            | `ghcr.io/r-hub/evercran/3.6.1`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.6.2            | `ghcr.io/r-hub/evercran/3.6.2`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 3.6.3            | `ghcr.io/r-hub/evercran/3.6.3`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 4.0.0            | `ghcr.io/r-hub/evercran/4.0.0`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 4.0.1            | `ghcr.io/r-hub/evercran/4.0.1`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 4.0.2            | `ghcr.io/r-hub/evercran/4.0.2`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 4.0.3            | `ghcr.io/r-hub/evercran/4.0.3`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 4.0.4            | `ghcr.io/r-hub/evercran/4.0.4`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 4.0.5            | `ghcr.io/r-hub/evercran/4.0.5`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 4.1.0            | `ghcr.io/r-hub/evercran/4.1.0`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 4.1.1            | `ghcr.io/r-hub/evercran/4.1.1`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 4.1.2            | `ghcr.io/r-hub/evercran/4.1.2`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 4.1.3            | `ghcr.io/r-hub/evercran/4.1.3`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 4.2.0            | `ghcr.io/r-hub/evercran/4.2.0`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 4.2.1            | `ghcr.io/r-hub/evercran/4.2.1`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 4.2.2            | `ghcr.io/r-hub/evercran/4.2.2`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 4.2.3            | `ghcr.io/r-hub/evercran/4.2.3`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 4.3.0            | `ghcr.io/r-hub/evercran/4.3.0`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 4.3.1            | `ghcr.io/r-hub/evercran/4.3.1`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 4.3.2            | `ghcr.io/r-hub/evercran/4.3.2`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 4.3.3            | `ghcr.io/r-hub/evercran/4.3.3`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 4.4.0            | `ghcr.io/r-hub/evercran/4.4.0`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 4.4.1            | `ghcr.io/r-hub/evercran/4.4.1`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |
| R 4.4.2            | `ghcr.io/r-hub/evercran/4.4.2`   | `linux/amd64`, `linux/arm64` | Debian bookworm 12.1  |

## Frequently asked questions

<details>
<summary>
Why does `list.files()` return an empty vector?
</summary>

If you see something like

    > list.files("/opt/R")
    character(0)

then you need to run the entry point of the container, see the question
after the next one.
</details>
<details>
<summary>
Why is the architecture detected as `x86_64` instead of `i386`?
</summary>
You need to run the entry point of the container, see the next question.
</details>
<details>
<summary>
`docker run` works, but `docker exec` does not, why?
</summary>

Running 32bit (`i386`) containers on arm64 and amd64 platforms is
tricky, and to make everything work properly, we need to run a special
entry point. This entry point runs with `docker run`, but it does not
for `docker exec`, and you need to run it manually:

    docker exec -it <container> entrypoint.sh bash

If you don’t run the entry point then on arm64 hosts you might get file
system errors (<https://github.com/r-hub/evercran/issues/7>). On amd64
platforms typically the architecture will be mis-detected
(<https://github.com/r-hub/evercran/issues/3>).
</details>

## Similar projects, inspiration

- [rcheology](https://github.com/hughjonesd/rcheology) – Data on Base
  Packages for Previous Versions of R
- [rang](https://github.com/chainsawriot/rang) – (Re)constructing R
  computational environments

## Thanks!

- [debian/eol](https://hub.docker.com/r/debian/eol/) – End of Life
  Debian versions (pointing at archive.debian.org)
- Posit’s <https://github.com/rstudio/r-builds> project.

## License

See <https://www.r-project.org/Licenses/> for the R licenses

The Dockerfiles and tools in this repository are licensed under the MIT
License.

© [R Consortium](https://github.com/rconsortium)
