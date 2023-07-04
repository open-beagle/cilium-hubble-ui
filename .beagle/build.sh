#!/usr/bin/env bashlinux

set -ex

export root=$PWD

cd $root/backend

export CGO_ENABLED=0

export GOARCH=amd64
mkdir -p "$root/build/linux-$GOARCH/"
go build -ldflags "-s -w" -o "$root/build/linux-$GOARCH/backend" github.com/cilium/hubble-ui/backend

export GOARCH=arm64
export CC=aarch64-linux-gnu-gcc
mkdir -p "$root/build/linux-$GOARCH/"
go build -ldflags "-s -w" -o "$root/build/linux-$GOARCH/backend" github.com/cilium/hubble-ui/backend

export GOARCH=ppc64le
export CC=powerpc64le-linux-gnu-gcc
mkdir -p "$root/build/linux-$GOARCH/"
go build -ldflags "-s -w" -o "$root/build/linux-$GOARCH/backend" github.com/cilium/hubble-ui/backend

export GOARCH=mips64le
export CC=mips64el-linux-gnuabi64-gcc
mkdir -p "$root/build/linux-$GOARCH/"
go build -ldflags "-s -w" -o "$root/build/linux-$GOARCH/backend" github.com/cilium/hubble-ui/backend

export GOARCH=loong64
export CC=loongarch64-linux-gnu-gcc
mkdir -p "$root/build/linux-$GOARCH/"
go build -ldflags "-s -w" -o "$root/build/linux-$GOARCH/backend" github.com/cilium/hubble-ui/backend