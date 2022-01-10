all: build

build:
	docker build -t local/ghostbin .

run_attach:
	docker run --rm -it --entrypoint="/bin/sh" -p 8619:8619 -v $(shell pwd)/logs:/logs -v $(shell pwd)/data:/data local/ghostbin

run_local:
	docker run --rm -it -p 8619:8619 -v $(shell pwd)/logs:/logs -v $(shell pwd)/data:/data local/ghostbin

run_online:
	docker run --rm -it -p 8619:8619 -v $(shell pwd)/logs:/logs -v $(shell pwd)/data:/data borrougagnou/ghostbin-updated

clean_logs:
	rm -rf $(shell pwd)/logs/*
