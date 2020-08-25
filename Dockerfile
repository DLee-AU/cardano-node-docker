# Compiler Image (see BaseCompiler.Dockerfile for base image)
# --------------------------------------------------------------------------
FROM adalove/centos:8-ghc8.6.5-c3.2.0.0 AS compiler

# compile cardano-node
ARG NODE_VERSION
ARG NODE_REPOSITORY
ARG NODE_BRANCH

RUN git clone -b $NODE_BRANCH --recurse-submodules $NODE_REPOSITORY cardano-node

WORKDIR cardano-node

RUN git fetch --all --tags
RUN git checkout tags/$NODE_VERSION --quiet

RUN mkdir -p /binaries/
RUN cabal build all
# move binaries
RUN cp -L "/libsodium/cardano-node/dist-newstyle/build/x86_64-linux/ghc-8.6.5/cardano-cli-${NODE_VERSION}/x/cardano-cli/build/cardano-cli/cardano-cli" /binaries/
RUN cp -L "/libsodium//cardano-node/dist-newstyle/build/x86_64-linux/ghc-8.6.5/cardano-node-${NODE_VERSION}/x/cardano-node/build/cardano-node/cardano-node" /binaries/

# Compiler for the health check program written in Go
# -------------------------------------------------------------------------
FROM golang:1.15 AS healthCheckCompiler

COPY healthcheck healthcheck
WORKDIR healthcheck

RUN mkdir -p /binaries/
RUN go mod vendor && go build
RUN mv healthcheck /binaries/

# Main Image (see Base.Dockerfile for base image)
# -------------------------------------------------------------------------
FROM adalove/centos:8

# Documentation
ENV DFILE_VERSION "1.5"

# Add Lovelace user
RUN groupadd --gid 1402 cardano
RUN useradd -m --uid 1402 --gid 1402 lovelace

# Documentation
LABEL maintainer="Kevin Haller <keivn.haller@outofbits.com>"
LABEL version="${DFILE_VERSION}-node${NODE_VERSION}"
LABEL description="Blockchain node for Cardano (implemented in Haskell)."

COPY --from=compiler /binaries/cardano-node /usr/local/bin/
COPY --from=compiler /binaries/cardano-cli /usr/local/bin/
COPY --from=healthCheckCompiler /binaries/healthcheck /usr/local/bin/

USER lovelace

ENTRYPOINT ["cardano-node"]
