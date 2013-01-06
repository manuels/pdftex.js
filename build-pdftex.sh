#!/bin/bash
# script to build pdftex from a subset of TeX Live sources

set -e
set -x

topDir=$(cd $(dirname $0) && pwd)

pdftexDir=$topDir/src/texk/web2c/pdftexdir
if [ ! -d $pdftexDir ]; then
    echo "$pdftexDir not found"
    exit -1
fi

CFG_OPTS="\
    --enable-native-texlive-build \
    --enable-cxx-runtime-hack \
    --disable-shared \
    --disable-largefile \
    --without-x \
    --disable-all-pkgs \
    --disable-ptex \
    --enable-pdftex \
"

## workaround to disable system libraries; --enable-native-texlive-build should do that but somehow it didn't
DISABLE_SYSTEM_LIBS="\
    --without-system-freetype \
    --without-system-freetype2 \
    --without-system-gd \
    --without-system-graphite \
    --without-system-icu \
    --without-system-kpathsea \
    --without-system-libpng \
    --without-system-ptexenc \
    --without-system-t1lib \
    --without-system-teckit \
    --without-system-xpdf \
    --without-system-zlib \
"
CFG_OPTS="$CFG_OPTS $DISABLE_SYSTEM_LIBS"

buildDir=$(pwd)/build-pdftex
rm -rf $buildDir && mkdir $buildDir && cd $buildDir

export CONFIG_SHELL=/bin/bash
$topDir/src/configure $CFG_OPTS "$@" 2>&1 | tee configure.log

# try to find gnu make; we may need it
MAKE=make
if make -v 2>&1| grep "GNU Make" >/dev/null; then
    echo "Your make is a GNU-make; I will use that"
elif gmake -v >/dev/null 2>&1; then
    MAKE=gmake
    echo "You have a GNU-make installed as gmake; I will use that"
else
    echo "I can't find a GNU-make; I'll try to use make and hope that works."
    echo "If it doesn't, please install GNU-make."
fi

$MAKE | tee make.log
(cd $buildDir/texk/web2c; $MAKE pdftex) 2>&1 | tee -a make.log
ls -l $buildDir/texk/web2c/pdftex
