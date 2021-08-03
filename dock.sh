#! /bin/bash

set -x
set -e

cwd="$PWD"
repo_root="$(readlink -f "$(dirname "$0")"/..)"

image=srb2kappimage-build

docker build -t "$image" -f "$repo_root"/Dockerfile "$repo_root"

uid="$(id -u)"

docker run --privileged --rm -i -v "$repo_root":/ws:ro -v "$cwd":/out "$image" bash -xec 'cd /out && bash -xe /ws/build-everything.sh'
