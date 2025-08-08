#!/usr/bin/env bash

recording_path=/tmp/last_record_screen.mp4
gif_pallet_path=/tmp/last_record_screen_gif_pallet.png
gif_path=/tmp/last_record_screen.gif

# Produce a pallete from the video file
ffmpeg -i $recording_path -filter_complex "palettegen=stats_mode=full" "$gif_pallet_path" -y || exit

# Use pallete to produce a gif from the video file
ffmpeg -i "$recording_path" -i "$gif_pallet_path" -filter_complex "paletteuse=dither=sierra2_4a" "$gif_path" -y || exit

wl-copy < $gif_path
