# Source Provenance

This repository packages an aarch64 build of upstream
[PancakeTAS/lsfg-vk](https://github.com/PancakeTAS/lsfg-vk) for Armada OS on the AYN Odin 2
family.

## Current Binary

- Binary: `files/liblsfg-vk-layer.so`
- Architecture: ELF 64-bit ARM aarch64 shared object
- Upstream repository: `https://github.com/PancakeTAS/lsfg-vk.git`
- Upstream branch: `develop`
- Upstream revision: `8b0da2661c6f3473a7fccc8ba643880050e71642`
- Upstream tag/description: `v2.0.0-dev`
- Local source tree status at verification: clean
- Build ID: `33b68bc66d36dc235eae7e3abb353ad1c0a0a439`
- Build environment: Fedora userspace in Distrobox on immutable Armada OS
- Observed compiler string: `clang version 22.1.8 (Fedora 22.1.8-1.fc44)`
- SHA-256:
  `dc08b91937c998f30115f1fac48ffe40d5142ce8e80e4b68feb3fef6b675e804`

The packaged binary was verified byte-for-byte identical to the build artifact at
`lsfg-vk/build/lsfg-vk-layer/liblsfg-vk-layer.so` in the local upstream checkout.

## Recommended Future Release Metadata

For a future public release, record:

- upstream lsfg-vk repository URL
- upstream lsfg-vk commit hash
- any local patches, or an explicit statement that there were none
- Armada OS version
- Distrobox image and Fedora version used for the build
- compiler version
- build commands
- SHA-256 checksums for each release file

Keeping that metadata with the binary helps users audit the build and makes GPL source
correspondence easier to verify.
