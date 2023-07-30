#! /bin/bash

sourced=0
if [ -n "$ZSH_EVAL_CONTEXT" ]; then
    case $ZSH_EVAL_CONTEXT in *:file) sourced=1;; esac
elif [ -n "$KSH_VERSION" ]; then
    [ "$(cd $(dirname -- $0) && pwd -P)/$(basename -- $0)" != "$(cd $(dirname -- ${.sh.file}) && pwd -P)/$(bas
ename -- ${.sh.file})" ] && sourced=1
elif [ -n "$BASH_VERSION" ]; then
    (return 0 2>/dev/null) && sourced=1
else
    # All other shells: examine $0 for known shell binary filenames
    # Detects `sh` and `dash`; add additional shell filenames as needed.
    case ${0##*/} in sh|dash) sourced=1;; esac
fi

CRAN=http://cran.r-project.org
BUILD_DIR==/opt/R/${R_VERSION}

prepare() {
    mkdir -p /opt/R
}

install_requirements() {
    apt-get update -y
    apt-get install -y       \
	    checkinstall     \
	    xlibs-dev        \
	    patch            \
	    gcc              \
	    g77              \
	    f2c              \
	    libc6-dev        \
	    make             \
	    perl             \
	    m4               \
	    less             \
	    groff            \
	    libreadline5-dev \
	    tetex-bin        \
	    tetex-extra      \
	    bison            \
            #
}

fetch_r_source() {
    if [ -z "$1" ]; then
	echo "Usage: fetch_r_source <r-version>"
	return
    fi
    local rver="$1"
    local build_dir="/opt/R/${rver}"
    echo "Downloading R-${rver}"
    if [ "$rver" = "0.60" -o "$rver" = "0.61" ]; then
	local url="${CRAN}/src/base/R-0/R-${rver}.0.tgz"
    else
	local url="${CRAN}/src/base/R-0/R-${rver}.tgz"
    fi
    wget "$url" -O R.tgz
    tar xzf R.tgz
    rm R.tgz
    mv R-${rver} ${build_dir}
}

patch_r_source() {
    if [ -z "$1" ]; then
	echo "Usage: patch_r_source <r-version>"
	return
    fi
    local build_dir="/opt/R/${1}"
    (
	if [ -f patch/R-${1}.patch ]; then
	    echo "Applying patch patch/R-${1}.patch"
	    cp patch/R-${1}.patch ${build_dir}
	    cd ${build_dir}
	    patch -p1 < R-${1}.patch
	    rm R-${1}.patch
	fi
    )
}

configure_r() {
    if [ -z "$1" ]; then
	echo "Usage: configure_r <r-version>"
	return
    fi
    local build_dir="/opt/R/${1}"
    (
	cd ${build_dir}
	./configure                         \
	    --x-includes=/usr/X11R6/include \
	    --x-libraries=/usr/X11R6/lib
    )
}

build_r() {
    if [ -z "$1" ]; then
	echo "Usage: build_r <r-version>"
	return
    fi
    local build_dir="/opt/R/${1}"
    (
	cd ${build_dir}
	make
	grep '^install-help:' Makefile && make install-help
	grep '^install-html:' Makefile && make install-html
	# apparently we need this another time, otherwise the
	# files are empty
	grep '^install-help:' Makefile && make install-help
	grep '^help:' Makefile && make help
	grep '^docs:' Makefile && make docs
    )
}

install_r() {
    if [ -z "$1" ]; then
	echo "Usage: install_r <r-version>"
	return
    fi
    local build_dir="/opt/R/${1}"
    (
	cd ${build_dir}
	# we could probably clean up more...
	find ${build_dir} -name "*.o" | xargs rm
    )
}

package_r() {
    if [ -z "$1" ]; then
	echo "Usage: patch_r_source <r-version>"
	return
    fi
    local rver="$1"
    local build_dir="/opt/R/${1}"
    rm -rf /tmp/${rver}
    mv ${build_dir} /tmp/
    rm -rf ${build_dir}
    echo "GNU R statistical computation and graphics system" > \
	 description-pak
    # Need a hack to add dependencies
    export MAINTAINER="csardi.gabor@gmail.com
Depends: less, xlibs, libreadline5"
    checkinstall -D -y                               \
		 --arch i386                         \
		 --pkgname r-${rver}                 \
		 --pkgversion 1                      \
		 --pkgsource "https://r-project.org" \
		 --pkglicense "GPL 2.0"              \
		 --strip=yes --stripso=yes           \
		 --spec r.spec                       \
		 --delspec=no                        \
		 cp -r /tmp/${rver} ${build_dir}
}

build() {
    prepare
    fetch_r_source ${R_VERSION}
    install_requirements
    patch_r_source ${R_VERSION}
    configure_r ${R_VERSION}
    build_r ${R_VERSION}
    install_r ${R_VERSION}
    package_r ${R_VERSION}
}

if [ "$sourced" = "0" ]; then
    # quit on error
    set -e
    build
else
    # verbose if interactive
    set -x
fi
