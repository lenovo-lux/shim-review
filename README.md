This repo is for review of requests for signing shim.  To create a request for review:

- clone this repo
- edit the template below
- add the shim.efi to be signed
- add build logs
- add any additional binaries/certificates/SHA256 hashes that may be needed
- commit all of that
- tag it with a tag of the form "myorg-shim-arch-YYYYMMDD"
- push that to github
- file an issue at https://github.com/rhboot/shim-review/issues with a link to your tag
- approval is ready when the "accepted" label is added to your issue

Note that we really only have experience with using GRUB2 on Linux, so asking
us to endorse anything else for signing is going to require some convincing on
your part.

Here's the template:

*******************************************************************************
### What organization or people are asking to have this signed?
*******************************************************************************
Lenovo

*******************************************************************************
### What product or service is this for?
*******************************************************************************
LUX, a Linux distribution customized for Lenovo notebooks and desktops.

*******************************************************************************
### What's the justification that this really does need to be signed for the whole world to be able to boot it?
*******************************************************************************
Although primarly built for Lenovo hardware, LUX is designed to run on any platform that supports UEFI Secure Boot
and the easiest way to support the largest number of systems is to have a shim bootloader signed by Microsoft.`

*******************************************************************************
### Why are you unable to reuse shim from another distro that is already signed?
*******************************************************************************
LUX wants to employ Secure Boot for building a trusted operating system from Shim to GRUB to the kernel to kernel modules. Lenovo CA will be used to sign custom kernels, video drivers and as such needs a signed shim with our certificate such that we can sign the drivers to allow users to keep Secure Boot on.

*******************************************************************************
### Who is the primary contact for security updates, etc.?
The security contacts need to be verified before the shim can be accepted. For subsequent requests, contact verification is only necessary if the security contacts or their PGP keys have changed since the last successful verification.

An authorized reviewer will initiate contact verification by sending each security contact a PGP-encrypted email containing random words.
You will be asked to post the contents of these mails in your `shim-review` issue to prove ownership of the email addresses and PGP keys.
*******************************************************************************
- Name: Alan Belmonte Aquilino
- Position: Software Engineer
- Email address: aaquilino@lenovo.com
- PGP key fingerprint: 53B2 7082 912D 3C43 3330 FE89 6877 F31C 545D 8878

(Key should be signed by the other security contacts, pushed to a keyserver
like keyserver.ubuntu.com, and preferably have signatures that are reasonably
well known in the Linux community.)

*******************************************************************************
### Who is the secondary contact for security updates, etc.?
*******************************************************************************
- Name:  Mauricio Maniga
- Position: Software Engineer
- Email address: mmaniga1@lenovo.com
- PGP key fingerprint: FBE7 5DC1 E9A1 2B5F 8294 5568 4F36 FA5D C084 561D

(Key should be signed by the other security contacts, pushed to a keyserver
like keyserver.ubuntu.com, and preferably have signatures that are reasonably
well known in the Linux community.)

*******************************************************************************
### Were these binaries created from the 15.7 shim release tar?
Please create your shim binaries starting with the 15.7 shim release tar file: https://github.com/rhboot/shim/releases/download/15.7/shim-15.7.tar.bz2

This matches https://github.com/rhboot/shim/releases/tag/15.7 and contains the appropriate gnu-efi source.

*******************************************************************************
yes.

*******************************************************************************
### URL for a repo that contains the exact code which was built to get this binary:
*******************************************************************************
https://github.com/lenovo-lux/shim-review/tree/lux1.0-shim-x64-20230224

*******************************************************************************
### What patches are being applied and why:
*******************************************************************************
1) Make sbat_var.S parse right with buggy gcc/binutils #535
https://github.com/rhboot/shim/pull/535
2) Enable the NX compatibility flag by default. #530
https://github.com/rhboot/shim/pull/530
3) Add validation function for Microsoft signing #531
https://github.com/rhboot/shim/pull/531

*******************************************************************************
### If shim is loading GRUB2 bootloader what exact implementation of Secureboot in GRUB2 do you have? (Either Upstream GRUB2 shim_lock verifier or Downstream RHEL/Fedora/Debian/Canonical-like implementation)
*******************************************************************************
We use debian's implementation of GRUB2 - latest from bullseye (2.06-3)

*******************************************************************************
### If shim is loading GRUB2 bootloader and your previously released shim booted a version of grub affected by any of the CVEs in the July 2020 grub2 CVE list, the March 2021 grub2 CVE list, the June 7th 2022 grub2 CVE list, or the November 15th 2022 list, have fixes for all these CVEs been applied?

* CVE-2020-14372
* CVE-2020-25632
* CVE-2020-25647
* CVE-2020-27749
* CVE-2020-27779
* CVE-2021-20225
* CVE-2021-20233
* CVE-2020-10713
* CVE-2020-14308
* CVE-2020-14309
* CVE-2020-14310
* CVE-2020-14311
* CVE-2020-15705
* CVE-2021-3418 (if you are shipping the shim_lock module)

* CVE-2021-3695
* CVE-2021-3696
* CVE-2021-3697
* CVE-2022-28733
* CVE-2022-28734
* CVE-2022-28735
* CVE-2022-28736
* CVE-2022-28737

* CVE-2022-2601
* CVE-2022-3775
*******************************************************************************
Not applicable.
This is our first shim review submission. We have not previously released shims.

*******************************************************************************
### If these fixes have been applied, have you set the global SBAT generation on your GRUB binary to 3?
*******************************************************************************
Yes.

*******************************************************************************
### Were old shims hashes provided to Microsoft for verification and to be added to future DBX updates?
### Does your new chain of trust disallow booting old GRUB2 builds affected by the CVEs?
*******************************************************************************
Not applicable.
This is our first shim review submission. We have not previously released shims

*******************************************************************************
### If your boot chain of trust includes a Linux kernel:
### Is upstream commit [1957a85b0032a81e6482ca4aab883643b8dae06e "efi: Restrict efivar_ssdt_load when the kernel is locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1957a85b0032a81e6482ca4aab883643b8dae06e) applied?
### Is upstream commit [75b0cea7bf307f362057cc778efe89af4c615354 "ACPI: configfs: Disallow loading ACPI tables when locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=75b0cea7bf307f362057cc778efe89af4c615354) applied?
### Is upstream commit [eadb2f47a3ced5c64b23b90fd2a3463f63726066 "lockdown: also lock down previous kgdb use"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eadb2f47a3ced5c64b23b90fd2a3463f63726066) applied?
*******************************************************************************
Yes. They are all applied.

*******************************************************************************
### Do you build your signed kernel with additional local patches? What do they do?
*******************************************************************************
No pacthes.

*******************************************************************************
### If you use vendor_db functionality of providing multiple certificates and/or hashes please briefly describe your certificate setup.
### If there are allow-listed hashes please provide exact binaries for which hashes are created via file sharing service, available in public with anonymous access for verification.
*******************************************************************************
We don't use vendor_db.

*******************************************************************************
### If you are re-using a previously used (CA) certificate, you will need to add the hashes of the previous GRUB2 binaries exposed to the CVEs to vendor_dbx in shim in order to prevent GRUB2 from being able to chainload those older GRUB2 binaries. If you are changing to a new (CA) certificate, this does not apply.
### Please describe your strategy.
*******************************************************************************
This is our first shim review submission for LUX. We have not previously signed any second stage loaders or EFI binaries.

*******************************************************************************
### What OS and toolchain must we use to reproduce this build?  Include where to find it, etc.  We're going to try to reproduce your build as closely as possible to verify that it's really a build of the source tree you tell us it is, so these need to be fairly thorough. At the very least include the specific versions of gcc, binutils, and gnu-efi which were used, and where to find those binaries.
### If the shim binaries can't be reproduced using the provided Dockerfile, please explain why that's the case and what the differences would be.
*******************************************************************************
Included Dockerfile.

*******************************************************************************
### Which files in this repo are the logs for your build?
Build.log.

*******************************************************************************
### What changes were made since your SHIM was last signed?
*******************************************************************************
This is our first shim review submission.

*******************************************************************************
### What is the SHA256 hash of your final SHIM binary?
*******************************************************************************
5900792c563b2a47f8806afc2be18f472c016aec612fb8679550e7116457fe36  shimx64.efi

*******************************************************************************
### How do you manage and protect the keys used in your SHIM?
*******************************************************************************
Keys are managed and stored in a HSM.
Access is tightly controlled and operations are restricted to authorized individuals.

*******************************************************************************
### Do you use EV certificates as embedded certificates in the SHIM?
*******************************************************************************
No.

*******************************************************************************
### Do you add a vendor-specific SBAT entry to the SBAT section in each binary that supports SBAT metadata ( grub2, fwupd, fwupdate, shim + all child shim binaries )?
### Please provide exact SBAT entries for all SBAT binaries you are booting or planning to boot directly through shim.
### Where your code is only slightly modified from an upstream vendor's, please also preserve their SBAT entries to simplify revocation.
*******************************************************************************
yes.

SHIM:
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
shim,3,UEFI shim,shim,1,https://github.com/rhboot/shim
shim.lux,1,LUX,shim,15.7,mail:lux@lenovo.com

GRUB: 
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md 
grub,3,Free Software Foundation,grub,2.06,https://www.gnu.org/software/grub/ 
grub.debian,1,Debian,grub2,2.06-3,https://tracker.debian.org/pkg/grub2 
grub.lux,1,LUX,grub2,2.06-3-lux,mail:lux@lenovo.com

FWUPD:
sbat,1,UEFI shim,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
fwupd-efi,1,Firmware update daemon,fwupd,1.5.7,https://github.com/fwupd/fwupd 
fwupd-efi.debian,1,Debian,fupdw,1.5.7-4,https://tracker.debian.org/pkg/fwupd
fwupd-efi.lux,1,LUX,fupdw,1.5.7-4-lux,mail:lux@lenovo.com
*******************************************************************************
### Which modules are built into your signed grub image?
*******************************************************************************
all_video boot btrfs cat chain configfile cpuid cryptodisk echo efifwsetup efinet ext2 f2fs fat font gcry_arcfour gcry_blowfish gcry_camellia gcry_cast5 gcry_crc gcry_des gcry_dsa gcry_idea gcry_md4 gcry_md5 gcry_rfc2268 gcry_rijndael gcry_rmd160 gcry_rsa gcry_seed gcry_serpent gcry_sha1 gcry_sha256 gcry_sha512 gcry_tiger gcry_twofish gcry_whirlpool gettext gfxmenu gfxterm gfxterm_background gzio halt help hfsplus iso9660 jfs jpeg keystatus linux linuxefi loadenv loopback ls lsefi lsefimmap lsefisystab lssal luks lvm mdraid09 mdraid1x memdisk minicmd normal ntfs part_apple part_gpt part_msdos password_pbkdf2 play png probe raid5rec raid6rec reboot regexp search search_fs_file search_fs_uuid search_label sleep squash4 test tftp tpm true video xfs zfs zfscrypt zfsinfo


*******************************************************************************
### What is the origin and full version number of your bootloader (GRUB or other)?
*******************************************************************************
We use the lastest version from debian bullseye (2.06-3). 

*******************************************************************************
### If your SHIM launches any other components, please provide further details on what is launched.
*******************************************************************************
only FWUPD. 

*******************************************************************************
### If your GRUB2 launches any other binaries that are not the Linux kernel in SecureBoot mode, please provide further details on what is launched and how it enforces Secureboot lockdown.
*******************************************************************************
N/A.

*******************************************************************************
### How do the launched components prevent execution of unauthenticated code?
*******************************************************************************
We rely on existing Linux kernel mechanisms to prevent the execution of unauthenticated code. 
Our signed Linux packages have a common set of lockdown patches. 
Our signed grub2 packages include common secure boot patches so they will only load appropriately signed binaries.


*******************************************************************************
### Does your SHIM load any loaders that support loading unsigned kernels (e.g. GRUB)?
*******************************************************************************
No.

*******************************************************************************
### What kernel are you using? Which patches does it includes to enforce Secure Boot?
*******************************************************************************
5.15.62. It has the usual lockdown patches applied.

*******************************************************************************
### Add any additional information you think we may need to validate this shim.
*******************************************************************************
N/A.
