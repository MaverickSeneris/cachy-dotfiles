# Load CachyOS defaults
source /usr/share/cachyos-fish-config/cachyos-config.fish

# Disable CachyOS fastfetch greeting
function fish_greeting
    # Empty override
end

# Global npm config
set -gx PATH ~/.npm-global/bin $PATH

# Time
set hour (date "+%H")
set hourmin (date "+%H:%M")

# Weather calibrated for Rizal/Pauli 2 (Calauan station)
set rawweather (curl -s 'wttr.in/Calauan?format=%t%7C%c')
set parts (string split '|' -- $rawweather)

# Trim values
set temp (string trim -- $parts[1])
set weather_icon (string trim -- $parts[2])

# Greeting selector
if test $hour -lt 12
    set greet "Good morning"
else if test $hour -lt 18
    set greet "Good afternoon"
else
    set greet "Good evening"
end

# Gruvbox-styled greeting
set_color d79921; echo -n "󰣇 "
set_color d65d0e; echo -n "$greet, Maverick — "
set_color 689d6a; echo -n "$hourmin "
set_color d79921; echo -n "$temp "
echo "$weather_icon"
set_color normal

# Mako Reminder
function reminder
    ~/.local/bin/mako_reminder.sh $argv
end
funcsave reminder
set -x NVM_DIR "$HOME/.nvm"
