# lsfg-vk for AYN Odin 2 Portal (Armada OS, aarch64)

Native aarch64 build of [lsfg-vk](https://github.com/PancakeTAS/lsfg-vk) — Lossless Scaling
frame generation as a Vulkan layer — compiled for the AYN Odin 2 Portal running Armada OS.
Tested working on the Portal (Snapdragon 8 Gen 2 / Adreno 740 via Turnip), including x86
games running through Proton/FEX (e.g. Valheim).

Built from PancakeTAS/lsfg-vk commit `PUT_COMMIT_HASH_HERE` (run `git rev-parse --short HEAD`
in your build checkout and paste it here).

## Requirements

- AYN Odin 2 / Odin 2 Portal on Armada OS (default `armada` user assumed; other usernames
  are handled automatically by the installer)
- **Lossless Scaling purchased on Steam** and installed on the device. It will not launch —
  that's expected — but installing it puts `Lossless.dll` on disk, which this layer needs.
  **The DLL and its shaders are the property of THS / Lossless Scaling and are NOT included
  in this package under any circumstances.**

## Install

1. Extract this archive somewhere in your home directory.
2. Open a terminal in desktop mode (or SSH in) and run:

   ```
   cd <extracted folder>
   chmod +x install.sh
   ./install.sh
   ```

Everything installs to your home directory (`~/.local` and `~/.config/lsfg-vk`) — no root,
no changes to the read-only OS, survives system updates.

## Enable per game

In Steam, open the game's Properties → Launch Options and put the variables **before** any
existing command (only one `%command%` per line):

```
LSFGVK_MULTIPLIER=2 LSFGVK_FLOW_SCALE=0.5 LSFGVK_PERFORMANCE_MODE=1 /usr/libexec/armada/armada-game-launch %command%
```

Available variables: `LSFGVK_MULTIPLIER` (2–4), `LSFGVK_FLOW_SCALE` (0.25–1.0, higher =
less ghosting, more GPU load), `LSFGVK_PERFORMANCE_MODE` (1/0), `LSFGVK_PACING`.

Alternatively, add permanent per-game profiles in `~/.config/lsfg-vk/conf.toml` — see the
commented example the installer writes there. Profiles match on the game's process name
(`Something.exe` for Proton games; check with `ps aux | grep -i exe` while the game runs).

## Tips

- Start at 2×, flow scale 0.5, performance mode on. Raise flow scale to 0.75–1.0 to reduce
  ghosting if the GPU has headroom; try performance mode off for better quality in light games.
- Capping the game to a steady base framerate (30/40) usually looks better after 2× than an
  uncapped, fluctuating framerate.
- If the layer doesn't appear in `vulkaninfo --summary | grep -i lsfg`, check the
  `library_path` in `~/.local/share/vulkan/implicit_layer.d/VkLayer_LSFGVK_frame_generation.json`
  and please report your Armada OS version when filing an issue.

## Uninstall

Delete:

```
~/.local/lib/liblsfg-vk-layer.so
~/.local/share/vulkan/implicit_layer.d/VkLayer_LSFGVK_frame_generation.json
~/.config/lsfg-vk/
```

and remove the launch options from your games.

## Credits & license

- [PancakeTAS and the lsfg-vk contributors](https://github.com/PancakeTAS/lsfg-vk) — the
  entire frame-generation layer this package is a straight aarch64 compile of. GPL-3.0
  license (included as LICENSE.md in this repository); full source is available at the
  upstream repository at the commit noted above.
- THS / Lossless Scaling — authors of the frame-generation shaders, which are extracted
  on-device from each user's own purchased `Lossless.dll` and never redistributed.
- This package adds no code — it is a build + install script for the Odin 2 Portal.
