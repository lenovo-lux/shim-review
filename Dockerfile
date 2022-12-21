# v1f
FROM debian:bullseye
ARG CERT_FILE="LUX_CA_PUB.cer"

# dependencies
RUN apt-get -y -qq update
RUN apt-get -y -qq install gcc make bzip2 efitools curl wget git
# 
# clone shim
WORKDIR /build
RUN git clone --recursive -b 15.7 https://github.com/rhboot/shim.git shim-15.7
WORKDIR /build/shim-15.7

# apply Patch - Fix sbat_var.S
# Make sbat_var.S parse right with buggy gcc/binutils #535
# https://github.com/rhboot/shim/pull/535/
# https://github.com/rhboot/shim/commit/657b2483ca6e9fcf2ad8ac7ee577ff546d24c3aa
RUN git checkout 657b2483ca6e9fcf2ad8ac7ee577ff546d24c3aa

# apply Patch - Add validation function for Microsoft signing #531
# https://github.com/rhboot/shim/pull/531/commits
RUN wget -O post-process-pe.c  https://raw.githubusercontent.com/rhboot/shim/c0d78aa1c4d9d2add1e477d4e5a4f8cd28950b15/post-process-pe.c

# apply Patch - Fix NX Flag
# Enable the NX compatibility flag by default. #530
# https://github.com/rhboot/shim/pull/530/files
RUN wget -O BUILDING https://raw.githubusercontent.com/rhboot/shim/a53b9f7ceec1dfa1487f4d675573449c5b2a16fb/BUILDING
RUN wget -O Make.defaults https://raw.githubusercontent.com/rhboot/shim/a53b9f7ceec1dfa1487f4d675573449c5b2a16fb/Make.defaults
RUN wget -O Makefile https://raw.githubusercontent.com/rhboot/shim/a53b9f7ceec1dfa1487f4d675573449c5b2a16fb/Makefile
# Change Line 45 for NX Compatibility - False to True
RUN sed -i '45s/false/true/' post-process-pe.c

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
RUN objdump -s -j .sbatlevel /build/output/shimx64.efi
RUN objdump -j .sbat -s /build/output/shimx64.efi
RUN sha256sum /build/output/*
