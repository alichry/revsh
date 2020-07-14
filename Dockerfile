FROM centos:7

WORKDIR /root/build/revsh

COPY ./compile.sh /root

RUN yum update -y \
    && yum install -y gcc glibc-static make git \
    && yum install -y perl perl-core perl-IPC-Cmd perl-Data-Dumper perl-Text-Template \
    && cd ~/build \
    && git clone --branch OpenSSL_1_1_1 https://github.com/openssl/openssl.git \
    && cd openssl \
    && ./config no-shared -static \
    && make \
    # `make test` hangs/takes a long time for openssl-3.0.0-alpha
    && make test \
    && cd .. \
    && git clone --depth=1 https://github.com/emptymonkey/revsh.git \
    && cd revsh \
    && sed -Ei 's/^#define CALLING_CARD.*$/#define CALLING_CARD "kthread"/g' \
	 config.h
    # required for openssl-3.0.0-alpha
    #&& sed -Ei 's/^LIBS =.*$/LIBS = -ldl/g' Makefile \
    # `make all` generates and embed keys into binary, we don't want that.
    #&& make \
    #&& make install \
    # clean up
    #&& cd / \
    #&& rm -rf /tmp/openssl \
    #&& rm -rf /tmp/revsh

EXPOSE 2200

CMD /root/compile.sh
