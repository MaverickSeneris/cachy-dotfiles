#!/bin/bash

# Ensure fzf and pacman exist
command -v fzf >/dev/null 2>&1 || { echo "fzf not found. Install with: sudo pacman -S fzf"; exit 1; }
command -v pacman >/dev/null 2>&1 || { echo "pacman not found. Are you even on Arch?"; exit 1; }

# FZF configuration
fzf_args=(
  --multi
  --preview 'pacman -Sii {1} 2>/dev/null || echo "No details available"'
  --preview-window 'down:65%:wrap'
  --bind 'alt-p:toggle-preview'
  --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up'
  --bind 'alt-k:preview-up,alt-j:preview-down'
  --color 'pointer:green,marker:green'
  --prompt 'Install packages ❯ '
)

# Get package list
pkg_names=$(pacman -Slq | fzf "${fzf_args[@]}")

# Install if something was chosen
if [[ -n "$pkg_names" ]]; then
  echo -e "\nInstalling selected packages..."
  echo "$pkg_names" | tr '\n' ' ' | xargs sudo pacman -S --noconfirm
  if command -v omarchy-show-done &>/dev/null; then
    omarchy-show-done
  else
    notify-send "✅ Installation complete!"
  fi
else
  echo "No package selected. Exiting."
fi
