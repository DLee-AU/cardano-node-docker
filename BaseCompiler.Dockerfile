FROM adalove/centos:8

RUN dnf install git gcc gcc-c++ gmp-devel make zlib-devel systemd-devel libsodium-devel ncurses-devel ncurses-compat-libs -y

# install cabal v3.2.0
ARG CABAL_VERSION

ADD https://downloads.haskell.org/~cabal/cabal-install-${CABAL_VERSION}/cabal-install-${CABAL_VERSION}-x86_64-unknown-linux.tar.xz cabal-install.tar.xz
RUN tar -xf cabal-install.tar.xz && rm cabal-install.tar.xz cabal.sig
RUN mv cabal /usr/local/bin

RUN cabal update

# install ghc v8.6.5
ARG GHC_VERSION

ADD https://downloads.haskell.org/~ghc/${GHC_VERSION}/ghc-${GHC_VERSION}-x86_64-centos7-linux.tar.xz ghc.tar.xz
RUN tar -xf ghc.tar.xz
RUN cd ghc-${GHC_VERSION} && ./configure && make install
RUN rm -rf ghc-${GHC_VERSION} ghc.tar.xz

# Documentation
LABEL maintainer="Kevin Haller <keivn.haller@outofbits.com>"
LABEL version="8-ghc${GHC_VERSION}-c${CABAL_VERSION}"
LABEL description="CentOS 8 Image ready to compile the Cardano Node."


