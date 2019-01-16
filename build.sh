#!/bin/bash

set -e

if [[ -z $TRAVIS_OS_NAME ]]; then
    echo "TRAVIS_OS_NAME: must be set"
    exit 1
fi

pack="cargo run --manifest-path=$PWD/tools/pack/Cargo.toml --"
osname=$TRAVIS_OS_NAME
arch=$(uname -m)
target_dir=$PWD/target

case $TRAVIS_OS_NAME in
"windows")
    ext=zip
    bin=qc.exe
    ;;
*)
    ext=tar.gz
    bin=qc
    ;;
esac

target_bin="$target_dir/bin/${bin}"

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

cd $(dirname $target_bin)
$pack $archive $bin
exit 0
