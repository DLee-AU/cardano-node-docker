FROM centos:8

RUN dnf install epel-release -y
RUN dnf install libtool ncurses-compat-libs libsodium pkg-config -y

# Documentation
LABEL maintainer="Kevin Haller <keivn.haller@outofbits.com>"
LABEL version="ghc${GHC_VERSION}-c${CABAL_VERSION}"
LABEL description="CentOS 8 Image ready to run the Cardano Node."