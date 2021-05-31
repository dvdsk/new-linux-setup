#!/usr/bin/env bash
set -e

RED='\033[0;31m'
source deps.sh

# # rust
# rustup=$(ensure_rustup)
# $rustup "+nightly" component add rust-analyzer-preview
# exists rust-analyzer-preview || echo -e "${RED}please make sure $HOME/.cargo/bin is in path"

# rust
rustup=$(ensure_rustup)
$rustup component add rust-src
curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-linux \
	-o ~/.local/bin/rust-analyzer
chmod +x $HOME/.local/bin/rust-analyzer
exists rust-analyzer || echo -e "${RED}please make sure $HOME/.local/bin is in path"

# python
pip=$(ensure_pip)
$pip install --user --upgrade 'python-lsp-server[all]'

# # latex
cargo=$(ensure_cargo)
$cargo install --git https://github.com/latex-lsp/texlab.git --locked
exists texlab || echo -e "${RED}please make sure $HOME/.cargo/bin is in path"

# # bash
npm=$(ensure_npm)
make -p ~/.local/bin
$npm config set prefix '~/.local/'
$npm install -g bash-language-server
exists bash-language-server || echo -e "${RED}please make sure $($npm bin) is in path"
