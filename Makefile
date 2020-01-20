VERSION := 3.75

.EXPORT_ALL_VARIABLES:

.PHONY: all
all: build

.PHONY: build
build: build-linux build-win32

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
