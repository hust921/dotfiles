# ===== Global Settings / Variables =====
set -o nounset   # to cause an error if you use an empty variable
set -o noclobber # the '>' symbol not allowed to overwrite "existing" files
set -o pipefail  # cmd_a | cmd_b . Fails if cmd_a doesn't cleanly exit (0) 
readonly DOTDIR="$HOME/dotfiles"

echo "=== Running (rust) install ==="

echo "installing rustup"
(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y)

echo "setting rust env in path (install only)"
source "$HOME/.cargo/env"

echo "installing rustfmt (for formatting)"
rustup component add rustfmt

echo "installing clippy (for semantic linting)"
rustup component add clippy

echo "installing rls (Rust Language Server) & rust-src"
rustup component add rls rust-analysis rust-src

echo "installing rust-analyzer"
sudo curl -L https://github.com/rust-analyzer/rust-analyzer/releases/download/nightly/rust-analyzer-linux -o /usr/local/bin/rust-analyzer && \
sudo chmod 751 /usr/local/bin/rust-analyzer

echo "Installing pakages:"
cargo install bat fd-find ripgrep exa cargo-update

echo "=== Finished (rust) install ==="
