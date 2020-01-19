FROM alpine

RUN apk add --no-cache \
  build-base \
  curl \
  make

COPY entrypoint.sh /usr/local/sbin/entrypoint
RUN chmod +x /usr/local/sbin/entrypoint

WORKDIR /tmp/app

RUN curl -LO https://ftp.gnu.org/gnu/make/make-4.2.tar.gz
RUN tar -xzvf make-4.2.tar.gz
RUN cd make-4.2 && \
  mkdir build && cd build && \
  ../configure
RUN cd make-4.2/build && \
  make SHARED=0 CC='gcc -static'

WORKDIR /opt/app

ENTRYPOINT ["sh", "/usr/local/sbin/entrypoint"]
