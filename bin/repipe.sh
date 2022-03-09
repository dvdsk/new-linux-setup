#!/usr/bin/env bash

# Read file from stdin and send to remarkable with first argument
# as name or the name from_pipe

DIR=/tmp/repipe
mkdir -p $DIR

name=${1:-"from_pipe"}
name=${name}.pdf
path="$DIR/$name"
cat - > "$DIR/$name"
rmapi put "$DIR/$name"
