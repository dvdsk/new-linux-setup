#!/usr/bin/env bash

set -e

flatpak list --app --columns=name --columns=application | tail -n +1 | sed 's/\t\(.\+\)/ = flatpak run \1/' | cat - <(kickoff-dot-desktop) | kickoff --from-stdin
