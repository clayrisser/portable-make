FROM alpine

RUN apk add --no-cache \
  build-base \
  curl \
  make

WORKDIR /tmp/app

ARG VERSION=4.2
ENV VERSION=${VERSION}

RUN curl -LO https://ftp.gnu.org/gnu/make/make-${VERSION}.tar.gz
RUN tar -xzvf make-${VERSION}.tar.gz && \
  rm -f make-${VERSION}.tar.gz
RUN cd make-${VERSION} && \
  mkdir build && cd build && \
  ../configure
RUN cd make-${VERSION}/build && \
  make SHARED=0 CC='gcc -static'
RUN cd make-${VERSION}/build && \
  tar -czvf make-linux-${VERSION}.tar.gz make

COPY entrypoint.sh /usr/local/sbin/entrypoint
RUN chmod +x /usr/local/sbin/entrypoint

WORKDIR /opt/app

ENTRYPOINT ["sh", "/usr/local/sbin/entrypoint"]
