#!/usr/bin/env bash
set -e

wpctl set-default $(wpctl status | grep Starship/Matisse | head -n 2 | tail -n 1 | grep -E "[0-9][0-9]" -o | head -n 1)

wpctl set-default $(wpctl status | grep -A 999 "Sources:" |grep PCM2902 | head -n 2 | tail -n 1 | grep -E "[0-9][0-9]" -o | head -n 1)
