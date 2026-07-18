# Source Provenance

This repository packages an aarch64 build of upstream
[PancakeTAS/lsfg-vk](https://github.com/PancakeTAS/lsfg-vk) for Armada OS on the AYN Odin 2
family.

## Current Binary

- Binary: `files/liblsfg-vk-layer.so`
- Architecture: ELF 64-bit ARM aarch64 shared object
- Build ID: `33b68bc66d36dc235eae7e3abb353ad1c0a0a439`
- Observed compiler string: `clang version 22.1.8 (Fedora 22.1.8-1.fc44)`
- SHA-256:
  `dc08b91937c998f30115f1fac48ffe40d5142ce8e80e4b68feb3fef6b675e804`

The exact upstream lsfg-vk commit for this initial binary was not preserved in the build
artifact. That should be corrected for future releases by rebuilding from a checked-out
upstream commit and recording the commit hash here and in the release notes.

## Recommended Future Release Metadata

For a future public release, record:

- upstream lsfg-vk repository URL
- upstream lsfg-vk commit hash
- any local patches, or an explicit statement that there were none
- compiler and distro/container version used for the build
- build commands
- SHA-256 checksums for each release file

Keeping that metadata with the binary helps users audit the build and makes GPL source
correspondence easier to verify.
