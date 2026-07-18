# Rebuilding On Armada OS

Armada OS is Fedora-based but immutable, so build lsfg-vk inside a Fedora Distrobox rather
than installing build dependencies directly into the base OS.

These notes are intended for future releases where the exact upstream lsfg-vk commit should
be recorded before publishing the binary.

## Create Or Enter A Fedora Distrobox

If you already have the build container, enter it:

```sh
distrobox enter lsfg-vk-build
```

Example for creating one:

```sh
distrobox create --name lsfg-vk-build --image registry.fedoraproject.org/fedora:latest
distrobox enter lsfg-vk-build
```

## Install Build Tools

Inside the Distrobox:

```sh
sudo dnf install -y \
  git \
  cmake \
  ninja-build \
  clang \
  lld \
  vulkan-headers \
  vulkan-loader-devel \
  glslang \
  pkgconf-pkg-config
```

Depending on the upstream commit, additional packages may be required. If CMake reports a
missing dependency, install the matching Fedora `-devel` package inside the Distrobox and
record it in the release notes.

## Build From A Known Upstream Commit

```sh
git clone https://github.com/PancakeTAS/lsfg-vk.git
cd lsfg-vk
git switch release
git submodule update --init --recursive

git rev-parse HEAD
clang --version
cat /etc/fedora-release
```

Copy the commit hash and environment details into `SOURCE.md` before publishing.

Configure and build:

```sh
cmake -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=On

cmake --build build
```

Find the built layer:

```sh
find build -name 'liblsfg-vk*.so'
```

Then copy the rebuilt `liblsfg-vk-layer.so` into this packaging repository:

```sh
cp /path/to/liblsfg-vk-layer.so files/liblsfg-vk-layer.so
```

## Update Package Metadata

From this repository:

```sh
file files/liblsfg-vk-layer.so
shasum -a 256 files/liblsfg-vk-layer.so files/VkLayer_LSFGVK_frame_generation.json install.sh
```

Update `README.md` and `SOURCE.md` with the new checksum, upstream commit, Fedora image,
compiler version, and any build-command changes.
