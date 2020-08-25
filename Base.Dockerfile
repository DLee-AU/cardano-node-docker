FROM centos:8

# install dependencies 
RUN dnf install -y autoconf \
	epel-release \
	gcc \
	git \
	libtool \
	make \
	ncurses-compat-libs \
	&& dnf clean all

# install library libsodium
RUN git clone https://github.com/input-output-hk/libsodium.git

WORKDIR libsodium

RUN git checkout 66f017f1
RUN ./autogen.sh && ./configure
RUN make && make check && make install

# remove the source code of libsodium
RUN rm -rf ../libsodium

ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

# Documentation
LABEL maintainer="Kevin Haller <keivn.haller@outofbits.com>"
LABEL version="8"
LABEL description="CentOS 8 Image ready to run the Cardano Node."
