ls ~/.config/nvim/init.vim &>/dev/null \
    || { mkdir -p ~/.config/nvim; ln -s `pwd`/vimrc ~/.config/nvim/init.vim; } \
    || { echo "Can't link symlink neovim config"; exit 1; }
echo "Required packages, check & install..."
which brew \
    || { echo "Please install homebrew first"; exit 1; }
which nvim \
    || brew install neovim --force-bottle || exit 1
which python3 \
    || brew install python3 --force-bottle || exit 1
which python2 \
    || brew install python2 --force-bottle || exit 1
which cmake \
    || brew install cmake --force-bottle || exit 1
which rg \
    || brew install ripgrep --force-bottle || exit 1
which git \
    || brew install git --force-bottle || exit 1

echo "Nerd Font..."
ls ~/Library/Fonts/Hack\ Regular\ Nerd\ Font\ Complete\ Mono.ttf &>/dev/null || curl https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete%20Mono.ttf -o ~/Library/Fonts/Hack\ Regular\ Nerd\ Font\ Complete\ Mono.ttf

echo "NeoVim PlugInstall..."
nvim --headless +PlugInstall +qa
ls /usr/local/opt/universal-ctags/bin/ctags &>/dev/null || { echo "Optional: brew install --HEAD universal-ctags/universal-ctags/universal-ctags"; }
echo "Done."
