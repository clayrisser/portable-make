.PHONY: build
build:
	@docker-compose -f docker-build.yaml build
	@docker run --rm -v $(PWD):/opt/app portable-make-build:latest
