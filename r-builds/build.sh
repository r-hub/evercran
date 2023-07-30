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

prepare() {
    if [ -z "$1" ]; then
	echo "Usage: prepare <r-version>"
	return 100
    fi
    local rver=$1;
    if dpkg --compare-versions "${rver}" lt 0.62; then
        mkdir -p /opt/R
    fi
}

# Not all versions need all these, but we might as well
# install everything, it does not hurt

install_requirements() {
    apt-get update -y
    apt-get install -y       \
	    checkinstall     \
	    xlibs-dev        \
	    patch            \
	    gcc              \
	    g77              \
	    gcc-2.95         \
	    g77-2.95         \
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
	return 100
    fi
    local rver="$1"
    echo "Downloading R-${rver}"
    if [ "$rver" = "0.60" -o "$rver" = "0.61" -o "$rver" = "0.62" ]; then
	local url="${CRAN}/src/base/R-0/R-${rver}.0.tgz"
    else
	local url="${CRAN}/src/base/R-0/R-${rver}.tgz"
    fi
    wget "$url" -O R.tgz
    tar xzf R.tgz
    rm R.tgz
    if dpkg --compare-versions "${rver}" lt 0.62; then
        local build_dir="/opt/R/${rver}"
        mv R-${rver} ${build_dir}
    fi
}

patch_r_source() {
    if [ -z "$1" ]; then
	echo "Usage: patch_r_source <r-version>"
	return 100
    fi
    local rver="$1"
    if dpkg --compare-versions "${rver}" lt 0.62; then
        local build_dir="/opt/R/${rver}"
    else
        local build_dir="R-${rver}"
    fi
    (
	if [ -f patch/R-${rver}.patch ]; then
	    echo "Applying patch patch/R-${1}.patch"
	    cp patch/R-${rver}.patch ${build_dir}
	    cd ${build_dir}
	    patch -p1 < R-${rver}.patch
	    rm R-${rver}.patch
	fi
    )
}

configure_r() {
    if [ -z "$1" ]; then
	echo "Usage: configure_r <r-version>"
	return 100
    fi
    local rver="$1"
    if dpkg --compare-versions "${rver}" lt 0.62; then
        local build_dir="/opt/R/${rver}"
    else
        local build_dir="R-${rver}"
    fi
    (
	cd ${build_dir}
        if dpkg --compare-versions "${rver}" lt 0.62; then
	    ./configure                         \
	        --x-includes=/usr/X11R6/include \
	        --x-libraries=/usr/X11R6/lib
        elif dpkg --compare-versions "${rver}" lt 0.62.3; then
	    ./configure                         \
                --prefix="/opt/R/${rver}"       \
	        --x-includes=/usr/X11R6/include \
	        --x-libraries=/usr/X11R6/lib
        else
            ./configure                         \
                --prefix="/opt/R/${rver}"
        fi
    )
}

build_r() {
    if [ -z "$1" ]; then
	echo "Usage: build_r <r-version>"
	return 100
    fi
    local rver="$1"
    if dpkg --compare-versions "${rver}" lt 0.62; then
        local build_dir="/opt/R/${rver}"
    else
        local build_dir="R-${rver}"
    fi
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
        if dpkg --compare-versions "$rver" lt 0.62; then
	    find ${build_dir} -name "*.o" | xargs rm
        fi
    )
}

package_r_in_place() {
    if [ -z "$1" ]; then
	echo "Usage: package_r_in_place <r-version>"
	return 100
    fi
    local rver="$1"
    local build_dir="/opt/R/${rver}"
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

package_r() {
    if [ -z "$1" ]; then
	echo "Usage: package_r <r-version>"
	return 100
    fi
    local rver="$1"
    local build_dir="R-${rver}"
    echo "GNU R statistical computation and graphics system" > \
	 description-pak
    # Need a hack to add dependencies
    export MAINTAINER="csardi.gabor@gmail.com
Depends: less, xlibs, libreadline5"
    (
        cd ${build_dir}
        checkinstall -D -y                               \
		     --arch i386                         \
		     --pkgname r-${rver}                 \
		     --pkgversion 1                      \
		     --pkgsource "https://r-project.org" \
		     --pkglicense "GPL 2.0"              \
		     --strip=yes --stripso=yes           \
		     --spec r.spec                       \
		     --delspec=no                        \
		     make install
        cp r-*.deb ..
    )
}

build() {
    if [ -z "$1" ]; then
	echo "Usage: build <r-version>"
	return 100
    fi
    local rver="$1"
    prepare ${rver}
    fetch_r_source ${rver}
    install_requirements
    patch_r_source ${rver}
    configure_r ${rver}
    build_r ${rver}
    if dpkg --compare-versions "${rver}" lt 0.62; then
        package_r_in_place ${rver}
    else
        package_r ${rver}
    fi
}

if [ "$sourced" = "0" ]; then
    # quit on error
    set -e
    build ${R_VERSION}
else
    # verbose if interactive
    set -x
fi
