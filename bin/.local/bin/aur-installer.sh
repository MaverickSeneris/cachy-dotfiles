#!/bin/bash

# --- Check for dependencies ---
command -v yay >/dev/null 2>&1 || { echo "Error: yay not found. Install it with 'sudo pacman -S --needed git base-devel' then 'git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si'"; exit 1; }
command -v fzf >/dev/null 2>&1 || { echo "Error: fzf not found. Install it with 'sudo pacman -S fzf'"; exit 1; }

# --- FZF setup ---
fzf_args=(
  --multi
  --preview 'yay -Si {1} 2>/dev/null || echo "No details available"'
  --preview-window 'down:65%:wrap'
  --bind 'alt-p:toggle-preview'
  --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up'
  --bind 'alt-k:preview-up,alt-j:preview-down'
  --color 'pointer:green,marker:green'
  --prompt 'Install from AUR ❯ '
)

# --- Fetch package list ---
pkg_names=$(yay -Slq | fzf "${fzf_args[@]}")

# --- Install selected packages ---
if [[ -n "$pkg_names" ]]; then
  echo -e "\nInstalling selected AUR packages..."
  echo "$pkg_names" | tr '\n' ' ' | xargs yay -S --noconfirm
  if command -v omarchy-show-done &>/dev/null; then
    omarchy-show-done
  else
    notify-send "✅ AUR installation complete!"
  fi
else
  echo "No package selected. Exiting."
fi
