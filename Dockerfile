FROM ubuntu:bionic as base_image

# Ignore timezone prompt in apt
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y -q \
    ca-certificates \
    pkg-config \
    make \
    wget \
    tar \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

# Build OpenSSL
RUN OPENSSL_VER=1.1.1h \
 && wget https://www.openssl.org/source/openssl-$OPENSSL_VER.tar.gz \
 && tar -zxf openssl-$OPENSSL_VER.tar.gz \
 && cd openssl-$OPENSSL_VER/ \
 && ./config \
 && THREADS=8 \
 && make -j$THREADS \
 && make test \
 && make install -j$THREADS

RUN ldconfig

WORKDIR /home/cryptotest

CMD ["bash", "-c", "openssl speed -evp aes-128-gcm; openssl speed sha256"]

