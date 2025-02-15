all: build

build:
	docker build -t local/spectre .

run_attach:
	docker run --rm -it --entrypoint="/bin/sh" -p 8619:8619 -v $(shell pwd)/logs:/logs -v $(shell pwd)/data:/data local/spectre

run_local:
	docker run --rm -it -p 8619:8619 -v $(shell pwd)/logs:/logs -v $(shell pwd)/data:/data local/spectre

run_online:
	docker run --rm -it -p 8619:8619 -v $(shell pwd)/logs:/logs -v $(shell pwd)/data:/data borrougagnou/spectre-updated

clean_logs:
	rm -rf $(shell pwd)/logs/*
