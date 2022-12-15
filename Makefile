# v1e
#
# UEFI shim build/review makefile
#

SHELL=/bin/bash

#@ build:                       build the uefi shim bootloader using docker
.PHONY: build
build: Dockerfile
	docker build --no-cache -t shim . |& tee build.log && \
	c=`docker create shim` && \
	docker cp $$c:/build/output/shimx64.efi ./; \
	docker rm $$c


#@ clean:                       clean docker, logs and old generated binaries
.PHONY: clean
clean:
	-docker rmi shim
	rm build.log
	rm shimx64.efi
