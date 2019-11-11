#!/usr/bin/env bash

echo "Symlink config path: ~/.config/nvim/init.vim..."
ls ~/.config/nvim/init.vim &>/dev/null \
    || { mkdir -p ~/.config/nvim; ln -s `pwd`/vimrc ~/.config/nvim/init.vim; } \
    || { echo "Can't link symlink neovim config"; exit 1; }

which brew \
    || { echo "Please install homebrew first"; exit 1; }

echo "Brew update & cleanup."
brew update && brew cleanup \
    || { echo "Need root to fix homebrew"; sudo chown -R $(whoami) $(brew --prefix)/* ; } \
    || brew update && brew cleanup \
    || exit 1

BREW_PKGS=( neovim git python3 python2 cmake ripgrep boost shellcheck yamllint )

echo "Homebrew packages, check & install..."
for PKG_NAME in "${BREW_PKGS[@]}"; do
    echo "Checking for ${PKG_NAME}."
    brew list "${PKG_NAME}" &>/dev/null || which "${PKG_NAME}" &>/dev/null || brew install "${PKG_NAME}" --force-bottle || exit 1
done
echo "Checking for universal-ctags"
brew list universal-ctags &>/dev/null || brew install --HEAD universal-ctags/universal-ctags/universal-ctags || exit 1

echo "Checking for Nerd Font."

ls ~/Library/Fonts/Hack\ Regular\ Nerd\ Font\ Complete\ Mono.ttf &>/dev/null \
    || curl -L https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf \
    -o ~/Library/Fonts/Hack\ Regular\ Nerd\ Font\ Complete\ Mono.ttf \
    || exit 1

echo "Python helper packages"
pip2 show pynvim &>/dev/null || pip2 install pynvim || exit 1
pip3 show pynvim &>/dev/null || pip3 install pynvim || exit 1
pip3 show pylint &>/dev/null || pip3 install pylint || exit 1

echo "NeoVim PlugInstall..."
if [ -f ~/.vim/plugged/cpsm/bin/cpsm_cli ]; then
    nvim --headless +PlugInstall +qa
else
    nvim --headless +PlugInstall! +qa
fi

echo "Done."
