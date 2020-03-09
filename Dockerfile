# Compiler Image
FROM centos:8 AS compiler

# Created with help by Mark Stopka (https://github.com/2nd-Layer/docker-hub-cardano-images/blob/master/cardano-node/1.6.0/Dockerfile)

# install dependencies
RUN dnf install -y git openssl-devel systemd-devel zlib-devel

# ugly workaround for vty-5.25.1
RUN ln -s /usr/lib64/libtinfo.so.6 /usr/lib64/libtinfo.so

# install stack
ADD https://get.haskellstack.org/ stack_setup.sh
RUN sh stack_setup.sh && rm -f stack_setup.sh

# build cardano-node
ARG NODE_VERSION
ARG NODE_REPOSITORY
ARG NODE_BRANCH

RUN git clone -b $NODE_BRANCH --recurse-submodules $NODE_REPOSITORY cardano-node
WORKDIR cardano-node
RUN git fetch && git fetch --tags
RUN git checkout $NODE_VERSION
RUN git submodule update
RUN mkdir -p /binaries && stack install --local-bin-path=/binaries/

# Main Image
FROM centos:8

# Documentation
ENV DFILE_VERSION "1.0"

# Create Lovelace User
RUN groupadd cardano --gid 1024
RUN adduser lovelace -u 1023 --no-create-home
RUN usermod -a -G cardano lovelace

# Documentation
LABEL maintainer="Kevin Haller <keivn.haller@outofbits.com>"
LABEL version="${DFILE_VERSION}-${NODE_VERSION}"
LABEL description="Blockchain node for Cardano (implemented in Haskell)."

COPY --from=compiler /binaries/cardano-node /usr/local/bin/
COPY --from=compiler /binaries/cardano-cli /usr/local/bin/

# Choose Lovelace as user to run jormungandr
USER lovelace

ENTRYPOINT ["cardano-node"]
