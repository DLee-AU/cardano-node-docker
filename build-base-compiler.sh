#!/bin/bash
docker build -f BaseCompiler.Dockerfile \
           --build-arg GHC_VERSION=$1 \
           --build-arg CABAL_VERSION=$2 \
           --no-cache \
           -t "adalove/centos:8-ghc$1-c$2" .