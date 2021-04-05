# ===== Global Settings / Variables =====
set -o nounset   # to cause an error if you use an empty variable
set -o noclobber # the '>' symbol not allowed to overwrite "existing" files
set -o pipefail  # cmd_a | cmd_b . Fails if cmd_a doesn't cleanly exit (0) 
readonly DOTDIR="$HOME/dotfiles"

echo "=== Running (sys) install ==="
echo "Installing ag, the silver searcher"
sudo pacman -Ss the_silver_searcher

echo "Installing jq (json processor)"
sudo pacman -S jq

echo "Installing xq (xml processor)"
sudo curl -o /usr/local/bin/xq 'https://github.com/maiha/xq.cr/releases' && \
sudo chmod 751 /usr/local/bin/xq

echo "Installing xmllint"
sudo pacman -S libxml2

echo '"Installing" colors-test string'
sudo cp "$DOTDIR/colors-test" "/usr/local/bin/"
sudo chown "root:root" "/usr/local/bin/colors-test"
sudo chmod 751 "/usr/local/bin/colors-test"

echo "=== Finished (sys) install ==="
