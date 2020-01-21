VERSION := 3.75

.EXPORT_ALL_VARIABLES:

.PHONY: all
all: build

.PHONY: build
build: build-darwin build-linux build-win32

.PHONY: build-darwin
build-darwin: make-darwin-${VERSION}.tar.gz
make-darwin-${VERSION}.tar.gz:
ifeq ($(shell uname), Darwin)
	-@rm -rf build-darwin || true
	@mkdir -p build-darwin
	@cd build-darwin && curl -LO https://ftp.gnu.org/gnu/make/make-${VERSION}.tar.gz
	@cd build-darwin && \
		tar -xzvf make-${VERSION}.tar.gz && \
	  rm -f make-${VERSION}.tar.gz
	@cd build-darwin/make-${VERSION} && \
		mkdir build && cd build && \
		../configure
	@cd build-darwin/make-${VERSION}/build && \
		$(MAKE)
	@cd build-darwin/make-${VERSION}/build && \
		tar -czvf make-darwin-${VERSION}.tar.gz make
	@mv build-darwin/make-${VERSION}/build/make-darwin-${VERSION}.tar.gz .
	-@rm -rf build-darwin || true
endif

.PHONY: build-linux
build-linux: make-linux-${VERSION}.tar.gz
make-linux-${VERSION}.tar.gz:
	@docker-compose -f docker-build.yaml build
	@docker run --rm -v $(PWD):/opt/app portable-make-build:latest

.PHONY: build-win32
build-win32: make-win32-${VERSION}.tar.gz
make-win32-${VERSION}.tar.gz:
	-@rm -rf build-win32 || true
	@mkdir -p build-win32
	@cd build-win32 && \
		curl -LO https://steve.fi/Software/make/make.zip
	@cd build-win32 && \
		unzip make.zip
	@cd build-win32 && \
		tar -czvf make-win32-${VERSION}.tar.gz make.exe
	@mv build-win32/make-win32-${VERSION}.tar.gz .
	-@rm -rf build-win32 || true

.PHONY: clean
clean:
	@git clean -fXd
