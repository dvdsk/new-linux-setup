#!/usr/bin/env bash

if [[ $1 == "fullscreen" ]]; then
    geometry=""
else
    geometry="-g \"$(slurp -w 0)\" "
fi

if [[ $2 == "clipboard" ]]; then
    output="- | wl-copy"
else
    mkdir -p ~/Pictures/screenshots
    output="-t png ~/Pictures/screenshots/$(date +%Y-%m-%d_%H:%M:%S).png"
fi

echo "grim $geometry$output" | bash
