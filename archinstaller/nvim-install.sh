# ===== Global Settings / Variables =====
set -o nounset   # to cause an error if you use an empty variable
set -o noclobber # the '>' symbol not allowed to overwrite "existing" files
set -o pipefail  # cmd_a | cmd_b . Fails if cmd_a doesn't cleanly exit (0) 
readonly DOTDIR="$HOME/dotfiles"


echo "=== Running (nvim) install ==="

# **Manual NeovimInstall**
# ```bash
pacman --noconfirm -S base-devel
git clone https://aur.archlinux.org/packages/neovim-nightly-bin
cd neovim-nightly-bin
makepkg -si
# ```
# - https://aur.archlinux.org/packages/neovim-nightly-bin

which nvim || echo "Install nvim manually first, see comment above"; exit 122

echo "Installing dependencies"
sudo pacman --noconfirm -Sy shellcheck
pip3 install pynvim jedi flake8

echo "Downloading and installing vim-plug" && \
curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
echo "Making $HOME/.config directory" && \
mkdir -p "$HOME/.config"

if ! [ -d "$HOME/.config/nvim" ]; then
ln -s "$DOTDIR/config/nvim" "$HOME/.config/nvim"
fi

echo "Installing Neovim Plugins"
/usr/bin/nvim +PlugInstall +UpdateRemotePlugins +qall
echo "=== Finished (nvim) install ==="
