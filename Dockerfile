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

RUn echo -e "package cardano-crypto-praos\n  flags: -external-libsodium-vrf" > cabal.project.local

RUN mkdir -p /binaries/
RUN cabal install cardano-node cardano-cli --installdir=/binaries/ \
		--install-method=copy

# Main Image
# -------------------------------------------------------------------------
FROM adalove/centos:8

# Documentation
ENV DFILE_VERSION "1.3"

# Documentation
LABEL maintainer="Kevin Haller <keivn.haller@outofbits.com>"
LABEL version="${DFILE_VERSION}-node${NODE_VERSION}"
LABEL description="Blockchain node for Cardano (implemented in Haskell)."

COPY --from=compiler /binaries/cardano-node /usr/local/bin/
COPY --from=compiler /binaries/cardano-cli /usr/local/bin/

ENTRYPOINT ["cardano-node"]
