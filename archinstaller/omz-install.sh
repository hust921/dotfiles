# ===== Global Settings / Variables =====
set -o nounset   # to cause an error if you use an empty variable
set -o noclobber # the '>' symbol not allowed to overwrite "existing" files
set -o pipefail  # cmd_a | cmd_b . Fails if cmd_a doesn't cleanly exit (0) 
readonly DOTDIR="$HOME/dotfiles"

echo "=== Running (omz) install ==="
sudo pacman --noconfirm -S zsh screenfetch

rm -rf "$HOME/.oh-my-zsh"
omzscript=$(mktemp /tmp/omz-XXXXXXXX)
if [[ -f "$omzscript" ]]; then
	rm -rf "$omzscript"
fi

curl -fsSL 'https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh' > "$omzscript"
chmod u+x "$omzscript"
sh -c "yes | $omzscript"
sudo usermod -s /bin/zsh "$(whoami)"

rm -rf "$HOME/.zshrc"
ln -s "$DOTDIR/zshrc" "$HOME/.zshrc"

echo "linking .oh-my-zsh/custom"
rm -rf "$HOME/.oh-my-zsh/custom"
ln -s "$DOTDIR/custom" "$HOME/.oh-my-zsh/custom"

echo "installing plugins"
"$DOTDIR/plugins/install.sh"
newPlugins=$(find $DOTDIR/plugins/ -maxdepth 1 -type d -not -name plugins -exec basename {} \;)
echo "linking .oh-my-zsh/plugins: "
for plugname in $newPlugins; do
	echo -e "$plugname, "
	ln -s "$DOTDIR/plugins/$plugname" "$HOME/.oh-my-zsh/plugins/$plugname" && \
	chmod -R go-w "$HOME/.oh-my-zsh/plugins/$plugname"
done
echo ""

rm -rf "$HOME/.zcompdump*" # Remove cache
