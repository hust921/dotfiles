# hust921 dotfiles
My personal dotfiles for omz, vim, tmux, conky, etc..

# Installation

### Overall Dependencies
* git
* curl
* fzf

**fzf** is a fuzzyfinder for zsh and vim. **Recommended see:** [Github-repo](https://github.com/junegunn/fzf)
```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### Semi-interactive installation
The install.sh scripts allows to select which files to replace. For the script to work it must be located in either /home/user/dotfiles or /root/dotfiles. If run as root it will automatically install (after a warning) the files in the root home.

*This script will NOT install the necessary dependencies!* yet.


## Install vim & dependencies
**Packages:**
* vim-nox           : Python support
* build-essential	: gcc, dep for .deb packages
* cmake             : Yet another build tool
* python-dev        : Python file header, yada yada
* clang             : LLVM C compiler (for YCM C support)
* mono-xbuild       : Mono/C# support for YCM
* ctags             : Exuberant ctags. Create tag file to nativagate source.

**Install dependencies (Debian based):**
```bash
sudo apt-get install vim vim-nox build-essential cmake python-dev clang mono-xbuild ctags
```
Install nerd-font. To work with vim-devicons. I'm using "DejaVu Sans Mono Regular" atm.
https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20for%20Powerline%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.ttf
**Link to vim files:**
```bash
cd ~/dotfiles/
./install.sh
# Select "replace vimrc & vimfiles"
# Or manually delete and link to files.
# Now also install and compiles tern
```

**Install plugins:**
```bash
vim +PluginInstall +qall
```

**Tern javascript completion**
```bash
cd ~/vimfiles/bundle/tern_for_vim/
npm install

```

**Compile YCM with C & C# support:** [Check YCM docs for compile flags.](https://github.com/Valloric/YouCompleteMe)
```bash
cd ~/vimfiles/bundle/YouCompleteMe/
./install.py --clang-completer --omnisharp-completer --tern-completer
```

## Install tmux
**Install tmux itself:**
```bash
sudo apt-get install tmux
```
**Link to tmux config:**
```bash
cd ~/dotfiles/
./install.sh
# Select "replace tmux.conf"
# Or manually delete and link to file.
```

## Install conky
**Install conky itself:**
```bash
sudo apt-get install conky
```
**Link to conky config:**
```bash
cd ~/dotfiles/
./install.sh
# Select "replace conkyrc"
# Or manually delete and link to file.
```

## Install OMZ
**Packages:**
* zsh
* screenfetch (optional)

**Install dependencies (Debian based):**
```bash
sudo apt-get install zsh screenfetch
```

**See repo for install instructions:**
[Oh-My-Zsh repo](https://github.com/robbyrussell/oh-my-zsh)

As of now (2-Sep-2015):
```bash
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

**Link to OMZ files:**
```bash
cd ~/dotfiles/
./install.sh
# Select "replace oh-my-zsh (omz)"
# Or manually delete and link to file.
```

## Install Powerline
**Packages:**
* python-pip

**Install dependencies (Debian based):**
```bash
sudo apt-get install python-pip
```

**Install globally. (As used in configs):**
```bash
sudo pip install powerline-status
```

# Credits

Author: Morten Lund [ <92morten@gmail.com> ]

Thank the awesome VIM, YCM and OMZ communities. For making awesome plugins and documentation. All vim plugins are added as github user/repo.


# License

MIT. See LICENSE file.
