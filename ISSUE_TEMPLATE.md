Confirm the following are included in your repo, checking each box:

 - [ ] completed README.md file with the necessary information
 - [ ] shim.efi to be signed
 - [ ] public portion of your certificate(s) embedded in shim (the file passed to VENDOR_CERT_FILE)
 - [ ] binaries, for which hashes are added to vendor_db ( if you use vendor_db and have hashes allow-listed )
 - [ ] any extra patches to shim via your own git tree or as files
 - [ ] any extra patches to grub via your own git tree or as files
 - [ ] build logs
 - [ ] a Dockerfile to reproduce the build of the provided shim EFI binaries

*******************************************************************************
### What is the link to your tag in a repo cloned from rhboot/shim-review?
*******************************************************************************
https://github.com/lenovo-lux/shim-review/tree/lux1.0-shim-x64-ia32-20221215

*******************************************************************************
### What is the SHA256 hash of your final SHIM binary?
*******************************************************************************

e1d41c65759939b128a2662ad71c28eaf1be97da51e95f49563396468768134d  shimx64.efi

*******************************************************************************
### What is the link to your previous shim review request (if any, otherwise N/A)?
*******************************************************************************
N/A. This is our first request.
