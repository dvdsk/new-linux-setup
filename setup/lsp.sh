#!/usr/bin/env bash
set -e

source deps.sh

# rust
rustup=$(ensure_rustup)
$rustup "+nightly" component add rust-analyzer-preview

# python
pip=$(ensure_pip)
$pip install 'python-lsp-server[all]'

# latex
cargo=$(ensure_cargo)
$cargo install --git https://github.com/latex-lsp/texlab.git --locked

# bash
npm=$(ensure_npm)
$npm i -g bash-language-server
