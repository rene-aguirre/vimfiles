#!/usr/bin/env bash

USRLOCALBIN="/usr/local/bin"
[[ ":$PATH:" != *":${USRLOCALBIN}:"* ]] && export PATH="${USRLOCALBIN}:${PATH}"

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

BREW_PKGS=( neovim ripgrep boost shellcheck )

echo "Homebrew packages, check & install..."
for PKG_NAME in "${BREW_PKGS[@]}"; do
    echo "Checking for ${PKG_NAME}."
    brew list "${PKG_NAME}" &>/dev/null || brew install "${PKG_NAME}" --force-bottle || exit 1
done

# maybe already installed (system)
BREW_PKGS=( git cmake )

for PKG_NAME in "${BREW_PKGS[@]}"; do
    echo "Checking for ${PKG_NAME}."
    which "${PKG_NAME}" &>/dev/null || brew list "${PKG_NAME}" &>/dev/null || brew install "${PKG_NAME}" --force-bottle || exit 1
done

echo "Checking for universal-ctags"
brew list universal-ctags &>/dev/null || brew install --HEAD universal-ctags/universal-ctags/universal-ctags || exit 1

echo "Checking for Nerd Font."

ls ~/Library/Fonts/Hack\ Regular\ Nerd\ Font\ Complete\ Mono.ttf &>/dev/null \
    || curl -L https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf \
    -o ~/Library/Fonts/Hack\ Regular\ Nerd\ Font\ Complete\ Mono.ttf \
    || exit 1

echo "Checking python2"
which python2 &>/dev/null || \
    which python2.7 &>/dev/null || \
    brew list python2 &>/dev/null || \
    brew install python2

which python2 &>/dev/null || \
    which python2.7 &>/dev/null && \
    ln -s `which python2.7` /usr/local/bin/python2

which python2 &>/dev/null || \
    { echo "Couldn't install python2!"; exit 1; }

echo "Checking python3"
which python3 &>/dev/null || \
    which python3.7 &>/dev/null || \
    brew list python3 &>/dev/null || \
    brew install python3

which python3 &>/dev/null || \
    which python3.7 &>/dev/null && \
    ln -s `which python3.7` /usr/local/bin/python3

which python3 &>/dev/null || \
    { echo "Couldn't install python3!"; exit 1; }

echo "Checking pip2"
which pip2 &>/dev/null || \
    which easy_install-2.7 &>/dev/null && \
    easy_install-2.7 -U --user pip && \
    ln -s ~/Library/Python/2.7/bin/pip /usr/local/bin/pip2

which pip2 &>/dev/null || \
    { echo "Can't find pip2 command, check pip version and link"; exit 1; }
    
echo "Checking pip3"
which pip3 &>/dev/null || \
    which easy_install-3.7 &>/dev/null && \
    easy_install-3.7 -U --user pip && \
    ln -s ~/Library/Python/3.7/bin/pip /usr/local/bin/pip3

which pip3 &>/dev/null || \
    { echo "Can't find pip3 command, check pip version and link"; exit 1; }

echo "Python helper packages"
pip2 show pynvim &>/dev/null || pip2 install --user pynvim || exit 1
pip3 show pynvim &>/dev/null || pip3 install --user pynvim || exit 1
pip3 show pylint &>/dev/null || pip3 install --user pylint || exit 1

echo "NeoVim PlugInstall..."
if [ -f ~/.vim/plugged/cpsm/bin/cpsm_cli ]; then
    nvim --headless +PlugInstall +qa
else
    nvim --headless +PlugInstall! +qa
fi

echo "Done."
