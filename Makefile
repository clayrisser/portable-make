VERSION := 3.81

.EXPORT_ALL_VARIABLES:

.PHONY: all
all: build

.PHONY: build
build: build-linux build-windows

.PHONY: build-linux
build-linux: make-linux-${VERSION}.tar.gz
make-linux-${VERSION}.tar.gz:
	@docker-compose -f docker-build.yaml build
	@docker run --rm -v $(PWD):/opt/app portable-make-build:latest

.PHONY: build-windows
build-windows: make-windows-${VERSION}.tar.gz
make-windows-${VERSION}.tar.gz:
	-@rm -rf build-windows || true
	@mkdir -p build-windows
	@cd build-windows && \
		curl -LO https://phoenixnap.dl.sourceforge.net/project/gnuwin32/make/${VERSION}/make-${VERSION}-bin.zip
	@cd build-windows && \
		unzip make-${VERSION}-bin.zip
	@cd build-windows/bin && tar -czvf make-windows-${VERSION}.tar.gz make.exe
	@mv build-windows/bin/make-windows-${VERSION}.tar.gz .
	-@rm -rf build-windows || true

.PHONY: clean
clean:
	@git clean -fXd
