#!/bin/bash

set -e

if [[ -z $TRAVIS_OS_NAME ]]; then
    echo "TRAVIS_OS_NAME: must be set"
    exit 1
fi

osname=$TRAVIS_OS_NAME
arch=$(uname -m)
target_dir=$PWD/target
target_bin=$target_dir/bin/qc
ext=tar.gz

if [[ $TRAVIS_OS_NAME == "windows" ]]; then
    apt-get install -y zip
    ext=zip
fi

if [[ -z $arch ]]; then
    echo "arch: missing"
    exit 1
fi

version=$(cat build_version)

if [[ -z $version ]]; then
    echo "Cannot find current version"
    exit 1
fi

archive=$PWD/target/upload/quickcfg-${version}-${osname}-${arch}.${ext}

# build if not bin
if [[ ! -f $target_bin ]]; then
    cargo install --root $target_dir --git https://github.com/udoprog/quickcfg --tag $version quickcfg
fi

if [[ ! -f $target_bin ]]; then
    echo "Missing: $target_bin"
    exit 1
fi

mkdir -p $(dirname $archive)

pushd $(dirname $target_bin)

case $ext in
"tar.gz")
    tar -cvzf $archive qc
    ;;
"zip")
    zip $archive qc
    ;;
*)
    echo "Bad extension: $ext"
    exit 1
    ;;
esac

exit 0
