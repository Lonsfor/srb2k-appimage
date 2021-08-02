#! /bin/bash

set -x
set -e

cwd="$PWD"
repo_root="$(readlink -f "$(dirname "$0")"/..)"

image=srb2kappimage-build:"$DIST"-"$ARCH"

docker build -t "$image" -f "$repo_root"/Dockerfile"

uid="$(id -u)"

docker run --rm -i -e ARCH -e GITHUB_RUN_NUMBER -e CI=1 -v "$repo_root":/ws:ro -v "$cwd":/out "$image" \
    bash -xec 'cd /out && bash -xe /ws/build-everything.sh'
