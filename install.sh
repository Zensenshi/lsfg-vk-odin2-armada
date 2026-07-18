#!/bin/bash
# lsfg-vk aarch64 installer for AYN Odin 2 Portal / Armada OS
# Installs entirely to the user's home directory - no root, no OS modification.
# Requires: Lossless Scaling purchased and installed via Steam (for Lossless.dll).
set -e

# --- locate the packaged files (works whether they sit in ./files or next to this script) ---
SRC=""
if [ -f "files/liblsfg-vk-layer.so" ]; then
    SRC="files"
elif [ -f "liblsfg-vk-layer.so" ]; then
    SRC="."
else
    echo "ERROR: liblsfg-vk-layer.so not found next to this script (or in ./files)."
    echo "Run install.sh from inside the extracted folder."
    exit 1
fi

if [ ! -f "$SRC/VkLayer_LSFGVK_frame_generation.json" ]; then
    echo "ERROR: VkLayer_LSFGVK_frame_generation.json not found in $SRC/."
    exit 1
fi

# --- find the user's Lossless.dll (never bundled - must come from their own Steam purchase) ---
DLL=$(find "$HOME/.steam" "$HOME/.local/share/Steam" -name "Lossless.dll" 2>/dev/null | head -1)
if [ -z "$DLL" ]; then
    echo "ERROR: Lossless.dll not found."
    echo "Install 'Lossless Scaling' from Steam on this device first (it won't launch - that's fine),"
    echo "then run this script again."
    exit 1
fi
echo "Found Lossless.dll: $DLL"

# --- install layer + manifest to user-level Vulkan paths ---
mkdir -p "$HOME/.local/lib" "$HOME/.local/share/vulkan/implicit_layer.d" "$HOME/.config/lsfg-vk"

cp "$SRC/liblsfg-vk-layer.so" "$HOME/.local/lib/"

# Rewrite library_path in the manifest to this user's absolute path,
# preserving the trailing comma required by the JSON structure.
sed "s|\"library_path\".*|\"library_path\": \"$HOME/.local/lib/liblsfg-vk-layer.so\",|" \
    "$SRC/VkLayer_LSFGVK_frame_generation.json" \
    > "$HOME/.local/share/vulkan/implicit_layer.d/VkLayer_LSFGVK_frame_generation.json"

# --- write a starter config only if none exists (don't clobber an existing setup) ---
CONF="$HOME/.config/lsfg-vk/conf.toml"
if [ -f "$CONF" ]; then
    echo "Existing $CONF found - leaving it untouched."
else
    cat > "$CONF" << EOF
version = 2

[global]
dll = "$DLL"

# Optional: add per-game profiles like this (matches on process/exe name):
# [[profile]]
# name = "My Game"
# active_in = ["Game.exe"]
# multiplier = 2
# flow_scale = 0.5
# performance_mode = true
EOF
    echo "Wrote starter config: $CONF"
fi

# --- verify the layer registers with Vulkan, if vulkaninfo is available ---
if command -v vulkaninfo >/dev/null 2>&1; then
    if vulkaninfo --summary 2>/dev/null | grep -qi lsfg; then
        echo "Verified: Vulkan sees VK_LAYER_LSFGVK_frame_generation."
    else
        echo "WARNING: vulkaninfo did not list the layer. Check the JSON in"
        echo "  $HOME/.local/share/vulkan/implicit_layer.d/"
    fi
else
    echo "(vulkaninfo not found - skipping verification.)"
fi

echo
echo "Done! To enable frame generation on a game, open its Steam Properties -> Launch Options"
echo "and put the variables BEFORE any existing command, e.g.:"
echo
echo '  LSFGVK_MULTIPLIER=2 LSFGVK_FLOW_SCALE=0.5 LSFGVK_PERFORMANCE_MODE=1 /usr/libexec/armada/armada-game-launch %command%'
echo
echo "(If the game already has launch options, keep them and add the LSFGVK_* variables at the front."
echo " Only one %command% per line.)"
echo
echo "To uninstall: delete the three files/dirs this script created under ~/.local and ~/.config/lsfg-vk."
