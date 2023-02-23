# v1g - Git Patch
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

# Make sbat_var.S parse right with buggy gcc/binutils #535
# https://github.com/rhboot/shim/pull/535/
# https://github.com/rhboot/shim/commit/657b2483ca6e9fcf2ad8ac7ee577ff546d24c3aa
RUN git checkout 657b2483ca6e9fcf2ad8ac7ee577ff546d24c3aa

# Enable the NX compatibility flag by default. #530
# https://github.com/rhboot/shim/pull/530
# https://github.com/rhboot/shim/commit/7c7642530fab73facaf3eac233cfbce29e10b0ef
RUN git checkout 7c7642530fab73facaf3eac233cfbce29e10b0ef

# apply Patch - Add validation function for Microsoft signing #531
# https://github.com/rhboot/shim/pull/531/commits
ADD 0001-MS_Validation_Patch.patch .
RUN git apply 0001-MS_Validation_Patch.patch

# include certificate and custom sbat
ADD ${CERT_FILE} .
ADD sbat.csv .

# append sbat data to the upstream data/sbat.csv
RUN cat sbat.csv >> data/sbat.csv && cat data/sbat.csv

# build
ADD LUX_CA_PUB.cer .
RUN mkdir build-x64
RUN make -C build-x64 ARCH=x86_64 VENDOR_CERT_FILE=../${CERT_FILE} TOPDIR=.. -f ../Makefile

# output
RUN mkdir /build/output
RUN cp build-x64/shimx64.efi /build/output
RUN cp ${CERT_FILE} /build/output
RUN objdump -s -j .sbatlevel /build/output/shimx64.efi
RUN objdump -j .sbat -s /build/output/shimx64.efi
RUN sha256sum /build/output/*
