# v1e
FROM debian:bullseye
ARG CERT_FILE="LUX_CA_PUB.cer"
ARG SHIM_URL="https://github.com/rhboot/shim/releases/download/15.7/shim-15.7.tar.bz2"
ARG SHIM_HASH="87cdeb190e5c7fe441769dde11a1b507ed7328e70a178cd9858c7ac7065cfade  shim-15.7.tar.bz2"

# dependencies
RUN apt-get -y -qq update
RUN apt-get -y -qq install gcc make bzip2 efitools curl wget

# download shim, verify, extract
WORKDIR /build
RUN curl --silent --location --remote-name ${SHIM_URL}
RUN echo "${SHIM_HASH}" | sha256sum --check
RUN tar -jxvpf $(basename ${SHIM_URL}) && rm $(basename ${SHIM_URL})
WORKDIR /build/shim-15.7

# apply PATCH
# Enable the NX compatibility flag by default. #530
# https://github.com/rhboot/shim/pull/530/files
RUN wget -O BUILDING https://raw.githubusercontent.com/rhboot/shim/a53b9f7ceec1dfa1487f4d675573449c5b2a16fb/BUILDING
RUN wget -O Make.defaults https://raw.githubusercontent.com/rhboot/shim/a53b9f7ceec1dfa1487f4d675573449c5b2a16fb/Make.defaults
RUN wget -O Makefile https://raw.githubusercontent.com/rhboot/shim/a53b9f7ceec1dfa1487f4d675573449c5b2a16fb/Makefile
RUN wget -O post-process-pe.c https://raw.githubusercontent.com/rhboot/shim/a53b9f7ceec1dfa1487f4d675573449c5b2a16fb/post-process-pe.c

# include certificate and custom sbat
ADD ${CERT_FILE} .
ADD sbat.csv .

# append sbat data to the upstream data/sbat.csv
RUN cat sbat.csv >> data/sbat.csv && cat data/sbat.csv

# build
RUN mkdir build-x64
RUN make -C build-x64 ARCH=x86_64 VENDOR_CERT_FILE=../${CERT_FILE} TOPDIR=.. -f ../Makefile

# output
RUN mkdir /build/output
RUN cp build-x64/shimx64.efi /build/output
RUN cp ${CERT_FILE} /build/output
RUN objdump -j .sbat -s /build/output/shimx64.efi
RUN sha256sum /build/output/*
