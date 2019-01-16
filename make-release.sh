#!/bin/bash

set -e

version=$1

if [[ -z $version ]]; then
    echo "Usage: $0 <version>"
    exit 1
fi

echo $version > build_version
git add build_version
git commit -m "release $version"
git tag $version
git push origin HEAD HEAD:refs/tags/$version
