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
    # It does not hurt to always create this
    mkdir -p /opt/R
}

install_oyacc() {
    (
	cd /tmp
	wget http://r-historic.r-pkg.org/oyacc-1.34.tar.gz
	rm -rf oyacc-1.34
	tar xzf oyacc-1.34.tar.gz
	cd oyacc-1.34
	./configure --prefix=/usr/local/ --enable-yacc
	make
	DESTDIR=/usr/local/ BINDIR=bin/ make install
    )
}

# Not all versions need all these, but we might as well
# install everything, it does not hurt

install_requirements_sarge() {
    if [ -z "$1" ]; then
	echo "Usage: install_requirements_sarge <r-version>"
	return 100
    fi
    local rver="$1"

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
	    bison

    if dpkg --compare-versions "${rver}" le 0.7; then
	install_oyacc
    fi

    if dpkg --compare-versions "${rver}" ge 1.1.0; then
        apt-get install -y   \
                g++          \
                g++-2.95     \
                libjpeg-dev  \
                libpng-dev
    fi
    if dpkg --compare-versions "${rver}" ge 1.2.0; then
        apt-get install -y   \
                tcl8.4-dev   \
                tk8.4-dev
        ln -s /usr/include/tcl8.4/ /usr/include/tk8.4
    fi
    if dpkg --compare-versions "${rver}" ge 1.6.0; then
        apt-get install -y   \
                libpcre3-dev \
                libbz2-dev
    fi
}

install_requirements_wheezy() {
    if [ -z "$1" ]; then
	echo "Usage: install_requiremens_wheezy <r-version>"
	return 100
    fi
    local rver="$1"

    apt-get update -y
    apt-get install -y       \
            checkinstall     \
            libx11-dev       \
            patch            \
            gcc              \
            gfortran         \
            g+++             \
            libc6-dev        \
            make             \
            perl             \
            m4               \
            less             \
            libreadline-gplv2-dev \
            texlive-base     \
            texinfo          \
            libjpeg-dev      \
            libpng-dev       \
            tcl8.4-dev       \
            tk8.4-dev        \
            libpcre3-dev     \
            libbz2-dev       \
            wget

    if dpkg --compare-versions "$rver" ge 2.7.0; then
        apt-get install -y      \
                libcairo2-dev   \
                libpango1.0-dev
    fi

    if dpkg --compare-versions "$rver" ge 2.9.0; then
        apt-get install -y      \
                libicu-dev
    fi

    if dpkg --compare-versions "$rver" ge 2.10.0; then
        apt-get install -y      \
                liblzma-dev
    fi
}

install_requirements_squeeze() {
    if [ -z "$1" ]; then
	echo "Usage: install_requiremens_squeeze <r-version>"
	return 100
    fi
    local rver="$1"

    apt-get update -y
    apt-get install -y       \
            checkinstall     \
            libx11-dev       \
            patch            \
            gcc              \
            gfortran         \
            g+++             \
            libc6-dev        \
            make             \
            perl             \
            m4               \
            less             \
            libreadline-dev  \
            texlive-base     \
            texinfo          \
            libjpeg-dev      \
            libpng-dev       \
            tcl8.4-dev       \
            tk8.4-dev        \
            libpcre3-dev     \
            libbz2-dev       \
            wget

    if dpkg --compare-versions "$rver" ge 2.7.0; then
        apt-get install -y      \
                libcairo2-dev   \
                libpango1.0-dev
    fi

    if dpkg --compare-versions "$rver" ge 2.9.0; then
        apt-get install -y      \
                libicu-dev
    fi

    if dpkg --compare-versions "$rver" ge 2.10.0; then
        apt-get install -y      \
                liblzma-dev
    fi
}

install_requirements() {
    if [ -z "$1" ]; then
	echo "Usage: install_requiremens <r-version>"
	return 100
    fi
    local rver="$1"
    if grep '^3[.]' /etc/debian_version; then
        install_requirements_sarge "$rver"
    elif grep '^6[.]' /etc/debian_version; then
        install_requirements_squeeze "$rver"
    elif grep '^7[.]' /etc/debian_version; then
        install_requirements_wheezy "$rver"
    fi
}

fetch_r_source() {
    if [ -z "$1" ]; then
	echo "Usage: fetch_r_source <r-version>"
	return 100
    fi
    local rver="$1"
    echo "Downloading R-${rver}"
    local major=`echo $rver | sed 's/\..*$//'`
    if [ "$rver" = "0.99.0" ]; then
        local url="${CRAN}/src/base/R-${major}/R-${rver}a.tgz"
    elif [ "$rver" = "0.0" ]; then
	local url="http://r-historic.r-pkg.org/R-unix-src.tar.gz"
    elif [ "$rver" = "0.60" -o "$rver" = "0.61" -o "$rver" = "0.62" \
                 -o "$rver" = "0.63" ]; then
	local url="${CRAN}/src/base/R-${major}/R-${rver}.0.tgz"
    elif [ "$rver" = "0.10" -o "$rver" = "0.11" ]; then
	local url="http://r-historic.r-pkg.org/R-${rver}alpha.tgz"
    elif dpkg --compare-versions "$rver" le 0.16.1; then
	local url="http://r-historic.r-pkg.org/R-${rver}alpha.tar.gz"
    elif dpkg --compare-versions "$rver" lt 2.0.0; then
        local url="${CRAN}/src/base/R-${major}/R-${rver}.tgz"
    else
        local url="${CRAN}/src/base/R-${major}/R-${rver}.tar.gz"
    fi
    wget "$url" -O R.tgz
    if dpkg --compare-versions "$rver" le 0.16.1; then
	mkdir R-${rver}
	tar xzf R.tgz -C R-${rver}
    else
	tar xzf R.tgz
	if [ "$rver" = "0.99.0" ]; then
            mv R-0.99.0a R-0.99.0
	fi
    fi
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

configure_r_historic() {
    if [ -z "$1" ]; then
	echo "Usage: configure_r_historic <r-version>"
	return 100
    fi
    local rver="$1"
    local build_dir="/opt/R/${rver}"
    (
	cd "${build_dir}"
        export "PATH=/usr/X11R6/bin:$PATH"
	cd src
	if dpkg --compare-versions "${rver}" le 0.10; then
	    ./configure Linux
	else
	    ./configure Linux-elf
	fi
    )
}

configure_r() {
    if [ -z "$1" ]; then
	echo "Usage: configure_r <r-version>"
	return 100
    fi
    local rver="$1"

    if dpkg --compare-versions "${rver}" le 0.12; then
	configure_r_historic "${rver}"
	return "$?"
    fi

    if dpkg --compare-versions "${rver}" lt 0.62; then
        local build_dir="/opt/R/${rver}"
    else
        local build_dir="R-${rver}"
    fi
    (
	cd ${build_dir}
        rm -rf config.cache
        export "PATH=/usr/X11R6/bin:$PATH"
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
            local args="--prefix=/opt/R/${rver}"
            if dpkg --compare-versions "${rver}" ge 1.2.0; then
                local args="$args --with-tcltk=/usr/lib/tcl8.4:/usr/lib/tk8.4"
                local args="$args --enable-R-shlib"
            fi
            if dpkg --compare-versions "$rver" ge 1.7.0; then
                if dpkg --compare-versions "$rver" le 1.7.1; then
                    # need to use internal zlib, otherwise fails to compile
                    local args="$args --with-zlib=no"
                fi
            fi
            ./configure $args
        fi
    )
}

build_r_historic() {
    if [ -z "$1" ]; then
	echo "Usage: build_r_historic <r-version>"
	return 100
    fi
    local rver="$1"
    local build_dir="/opt/R/${rver}"
    (
	cd "${build_dir}"
        export PATH="/usr/X11R6/bin:$PATH"
	export PATH=".:$PATH"
	mkdir -p library
	mkdir -p psmetrics
	mkdir -p html/funs
	cd src
	mkdir -p lib
	make
	if [ "$rver" = "0.5" ]; then
	    (
		cd library/mva
		make || true
	    )
	fi
	make install
	make help || make man.help || make man.html || true

	cd ..
	if [ "$rver" = "0.0" ]; then
	    cp R.sh bin/R
	fi
    )
}

build_r() {
    if [ -z "$1" ]; then
	echo "Usage: build_r <r-version>"
	return 100
    fi
    local rver="$1"

    if dpkg --compare-versions "${rver}" le 0.12; then
	build_r_historic "${rver}"
	return "$?"
    fi

    if dpkg --compare-versions "${rver}" lt 0.62; then
        local build_dir="/opt/R/${rver}"
    else
        local build_dir="R-${rver}"
    fi
    (
	cd ${build_dir}
	make
	if dpkg --compare-versions "${rver}" le 0.13; then
	    export PATH="`pwd`/mansrc/help:$PATH"
	fi
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
    if dpkg --compare-versions "$rver" ge 1.3.0; then
        if dpkg --compare-versions "$rver" le 1.5.1; then
            install_recommended "$rver"
        fi
    fi
}

install_recommended() {
    if [ -z "$1" ]; then
	echo "Usage: build_r <r-version>"
	return 100
    fi
    local rver="$1"
    local major=`echo $rver | sed 's/\..*$//'`
    local url="${CRAN}/src/base/R-${major}/R-${rver}-recommended.tgz"
    local build_dir="R-${rver}"
    (
        set +x
        cd "$build_dir"
        wget "$url" -O RC.tgz
        tar xzf RC.tgz
        rm RC.tgz
        for pkg in $(ls R-$rver-recommended | grep '.tar.gz$'); do
            ./bin/R CMD INSTALL "R-$rver-recommended/$pkg"
        done
        rm -r "R-$rver-recommended"
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
    local deps="less, libsm6, libice6, libx11-6, libc6, libreadline5"
    # Need a hack to add dependencies
    export MAINTAINER="csardi.gabor@gmail.com
Depends: $deps"
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
    if grep '^3[.]' /etc/debian_version; then
        package_r_sarge "$rver"
    elif grep '^6[.]' /etc/debian_version; then
        package_r_squeeze "$rver"
    elif grep '^7[.]' /etc/debian_version; then
        package_r_wheezy "$rver"
    fi
}

lookup_dep() {
    set +x
    local path="$1"
    ldd "$path"  | grep -F '=>' | awk '{ print $3; }' |
        grep ^/ | sort | uniq | xargs dpkg -S  |
        cut -d: -f1  | sort | uniq
}

lookup_deps() {
    set +x
    if [ -z "$1" ]; then
        echo "Usage: lookup_deps <path>"
        return 100
    fi
    local path="$1"
    # We don't need to look up the R binary, because we use --enable-R-shlib
    local sos=`find "$path" -name "*.so"`
    for so in $sos; do
        lookup_dep "$so"
    done | sort | uniq | tr '\n' , | sed 's/,$//' | sed 's/,/, /g'
}

package_r_wheezy() {
    if [ -z "$1" ]; then
	echo "Usage: package_r_wheezy <r-version>"
	return 100
    fi
    local rver="$1"
    local build_dir="R-${rver}"
    echo $build_dir
    local deps=`lookup_deps "$build_dir"`
    local deps="$deps, less"
    if dpkg --compare-versions "$rver" lt "2.12.0"; then
        local deps="$deps, perl"
    fi
    local arch="`dpkg --print-architecture`"

    (
        cd ${build_dir}
        echo "/opt/R/${rver}" > chk-list
        echo "GNU R statistical computation and graphics system" > \
	     description-pak

        make install

        checkinstall -D -y                                 \
		     --arch "$arch"                        \
		     --pkgname r-${rver}                   \
		     --pkgversion 1                        \
		     --pkgsource "https://r-project.org"   \
		     --pkglicense "GPL 2.0"                \
                     --maintainer="csardi.gabor@gmail.com" \
                     --requires="$deps"                    \
		     --strip=yes --stripso=yes             \
		     --spec r.spec                         \
		     --delspec=no                          \
                     --nodoc                               \
                     --include=chk-list                    \
		     echo ok
        cp r-*.deb ..
    )
}

package_r_squeeze() {
    if [ -z "$1" ]; then
	echo "Usage: package_r_squeeze <r-version>"
	return 100
    fi
    local rver="$1"
    local build_dir="R-${rver}"
    echo $build_dir
    local deps=`lookup_deps "$build_dir"`
    local deps="$deps, less"
    if dpkg --compare-versions "$rver" lt "2.12.0"; then
        local deps="$deps, perl"
    fi
    local arch="`dpkg --print-architecture`"

    (
        cd ${build_dir}
        echo "/opt/R/${rver}" > chk-list
        echo "GNU R statistical computation and graphics system" > \
	     description-pak

        make install

        checkinstall -D -y                                 \
		     --arch "$arch"                        \
		     --pkgname r-${rver}                   \
		     --pkgversion 1                        \
		     --pkgsource "https://r-project.org"   \
		     --pkglicense "GPL 2.0"                \
                     --maintainer="csardi.gabor@gmail.com" \
                     --requires="$deps"                    \
		     --strip=yes --stripso=yes             \
		     --spec r.spec                         \
		     --delspec=no                          \
                     --nodoc                               \
                     --include=chk-list                    \
		     echo ok
        cp r-*.deb ..
    )
}

package_r_sarge() {
    if [ -z "$1" ]; then
	echo "Usage: package_r_sarge <r-version>"
	return 100
    fi
    local rver="$1"
    local build_dir="R-${rver}"
    echo "GNU R statistical computation and graphics system" > \
	 description-pak
    local deps="less, libsm6, libice6, libx11-6, libc6, libreadline5"
    if dpkg --compare-versions "$rver" ge 0.64.0; then
        local deps="$deps, zlib1g"
    fi
    if dpkg --compare-versions "$rver" ge 1.1.0; then
        local deps="$deps, libjpeg62, libpng12-0"
    fi
    if dpkg --compare-versions "$rver" ge 1.2.0; then
        local deps="$deps, tcl8.4, tk8.4"
    fi
    if dpkg --compare-versions "$rver" ge 1.3.0; then
        local deps="$deps, libg2c0"
    fi
    if dpkg --compare-versions "$rver" ge 1.6.0 &&
            dpkg --compare-versions "$rver" le 1.8.1; then
        local deps="$deps, libbz2-1.0"
    fi
    # Need a hack to add dependencies
    export MAINTAINER="csardi.gabor@gmail.com
Depends: $deps"
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
    install_requirements ${rver}
    fetch_r_source ${rver}
    patch_r_source ${rver}
    configure_r ${rver}
    build_r ${rver}
    if dpkg --compare-versions "${rver}" lt 0.62; then
        package_r_in_place ${rver}
    else
        package_r ${rver}
    fi
    local debver="`cat /etc/debian_version`"
    for f in r-[0-9]*.deb; do
        mv "$f" "$(echo $f | sed 's/r-/r-evercran-debian-'${debver}'-/')"
    done
}

if [ "$sourced" = "0" ]; then
    # quit on error
    set -e
    build ${R_VERSION}
else
    # verbose if interactive
    set -x
fi
