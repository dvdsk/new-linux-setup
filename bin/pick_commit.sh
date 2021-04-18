#!/usr/bin/env bash

# short hash, description, relative time in green
format="%h %s %Cgreen%cr"
commit_hash=$(git log --all --color --format="${format}"\
	| sk --ansi \
	| cut -d " " -f 1)

git checkout $commit_hash
