FROM alpine

ARG VERSION=4.2
ENV VERSION=${VERSION}

RUN apk add --no-cache \
  build-base \
  curl \
  make

COPY entrypoint.sh /usr/local/sbin/entrypoint
RUN chmod +x /usr/local/sbin/entrypoint

WORKDIR /tmp/app

RUN curl -LO https://ftp.gnu.org/gnu/make/make-${VERSION}.tar.gz
RUN echo https://ftp.gnu.org/gnu/make/make-${VERSION}.tar.gz
RUN tar -xzvf make-${VERSION}.tar.gz && \
  rm -f make-${VERSION}.tar.gz
RUN cd make-${VERSION} && \
  mkdir build && cd build && \
  ../configure
RUN cd make-${VERSION}/build && \
  make SHARED=0 CC='gcc -static'
RUN cd make-${VERSION}/build && \
  tar -czvf make-${VERSION}.tar.gz make

WORKDIR /opt/app

ENTRYPOINT ["sh", "/usr/local/sbin/entrypoint"]
