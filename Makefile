VERSION := 4.2

.EXPORT_ALL_VARIABLES:

.PHONY: all
all: build

.PHONY: build
build:
	@docker-compose -f docker-build.yaml build
	@docker run --rm -v $(PWD):/opt/app portable-make-build:latest

.PHONY: clean
clean:
	@git clean -fXd
