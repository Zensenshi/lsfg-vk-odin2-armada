# lsfg-vk for AYN Odin 2 / Odin 2 Portal on Armada OS

Native aarch64 build of [lsfg-vk](https://github.com/PancakeTAS/lsfg-vk), the Lossless
Scaling frame generation Vulkan layer, packaged for Armada OS on the AYN Odin 2 family.

This package was tested on an AYN Odin 2 Portal running Armada OS with Snapdragon 8 Gen 2 /
Adreno 740 via Turnip, including x86 games running through Proton/FEX such as Valheim.

## What is included

- `files/liblsfg-vk-layer.so` - aarch64 Vulkan layer binary
- `files/VkLayer_LSFGVK_frame_generation.json` - Vulkan implicit layer manifest
- `install.sh` - user-local installer for Armada OS
- `LICENSE.md` - GPL-3.0 license text from upstream lsfg-vk

This repository does not include `Lossless.dll`, Lossless Scaling shaders, or any files from
the commercial Lossless Scaling Steam app.

## Requirements

- AYN Odin 2 or Odin 2 Portal running Armada OS
- Steam installed and configured on the device
- Lossless Scaling purchased on Steam and installed on the same device

Lossless Scaling is expected not to launch on Armada OS. Installing it is still required
because lsfg-vk reads the user's own `Lossless.dll` from the Steam install.

## Install

Extract or clone this repository somewhere in your home directory, then run:

```sh
cd lsfg-vk-portal
chmod +x install.sh
./install.sh
```

The installer writes only to user-level locations:

```text
~/.local/lib/liblsfg-vk-layer.so
~/.local/share/vulkan/implicit_layer.d/VkLayer_LSFGVK_frame_generation.json
~/.config/lsfg-vk/conf.toml
```

No root access is required, and the install does not modify the read-only OS image.

## Enable Per Game

In Steam, open the game's Properties, then put the variables before the game command in
Launch Options:

```sh
LSFGVK_MULTIPLIER=2 LSFGVK_FLOW_SCALE=0.5 LSFGVK_PERFORMANCE_MODE=1 /usr/libexec/armada/armada-game-launch %command%
```

Common options:

| Variable | Typical values | Notes |
| --- | --- | --- |
| `LSFGVK_MULTIPLIER` | `2`, `3`, `4` | Frame generation multiplier. Start with `2`. |
| `LSFGVK_FLOW_SCALE` | `0.25` to `1.0` | Higher can reduce ghosting but costs more GPU time. |
| `LSFGVK_PERFORMANCE_MODE` | `1` or `0` | Start with `1`; try `0` for better quality in lighter games. |
| `LSFGVK_PACING` | upstream default or custom | Frame pacing option exposed by lsfg-vk. |

You can also create per-game profiles in `~/.config/lsfg-vk/conf.toml`. Profiles match the
game process name, such as `Game.exe` for Proton games. If needed, check the process name
while the game is running:

```sh
ps aux | grep -i exe
```

## Recommended Starting Point

- Cap the game to a steady 30 or 40 FPS first.
- Start with `LSFGVK_MULTIPLIER=2`, `LSFGVK_FLOW_SCALE=0.5`, and
  `LSFGVK_PERFORMANCE_MODE=1`.
- Raise `LSFGVK_FLOW_SCALE` to `0.75` or `1.0` only if there is enough GPU headroom.
- Try performance mode off for lighter games if image quality matters more than GPU load.

## Verify

If `vulkaninfo` is installed, the installer attempts to verify the layer automatically. You
can also check manually:

```sh
vulkaninfo --summary | grep -i lsfg
```

If the layer is not listed, inspect:

```text
~/.local/share/vulkan/implicit_layer.d/VkLayer_LSFGVK_frame_generation.json
```

The manifest's `library_path` should point to the current user's
`~/.local/lib/liblsfg-vk-layer.so`.

## Checksums

```text
dc08b91937c998f30115f1fac48ffe40d5142ce8e80e4b68feb3fef6b675e804  files/liblsfg-vk-layer.so
c1f1a4c3848dea3ed68c3033a27c66ac54f9c25a9b650f086e5a91b552901949  files/VkLayer_LSFGVK_frame_generation.json
5bab0e2ae8c5257d1e4d943d108c7477e79e8ceaaa47b65da32c487cef2af1f8  install.sh
```

## Uninstall

Delete these paths:

```sh
rm -f ~/.local/lib/liblsfg-vk-layer.so
rm -f ~/.local/share/vulkan/implicit_layer.d/VkLayer_LSFGVK_frame_generation.json
rm -rf ~/.config/lsfg-vk
```

Then remove the `LSFGVK_*` launch options from your games.

## Source And License

lsfg-vk is GPL-3.0 software by PancakeTAS and contributors. This repository is a binary
package plus installer for Armada OS; it does not add or modify lsfg-vk source code.

This binary was built from upstream commit
`8b0da2661c6f3473a7fccc8ba643880050e71642` (`v2.0.0-dev`). See
[SOURCE.md](SOURCE.md) for source-provenance notes and [BUILD.md](BUILD.md) for the
recommended Fedora Distrobox rebuild workflow on immutable Armada OS.

Lossless Scaling is by THS. Users must provide their own Steam-purchased copy. This package
does not redistribute Lossless Scaling binaries or shaders.
