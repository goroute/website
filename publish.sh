#!/bin/bash
#
# This script builds and publishes docs to goroute.github.io.
set -e

hugo
cd ..
cp -rf ./website/public/* ./goroute.github.io
cd ./goroute.github.io
git add . && git commit -m "Update docs" && git push