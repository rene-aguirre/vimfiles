#!/usr/bin/env bash

USRLOCALBIN="/usr/local/bin"
[[ ":$PATH:" != *":${USRLOCALBIN}:"* ]] && export PATH="${USRLOCALBIN}:${PATH}"

echo "Symlink config path: ~/.config/nvim/init.vim..."
ls ~/.config/nvim/init.vim &>/dev/null \
    || { mkdir -p ~/.config/nvim; ln -sf "$(pwd)/vimrc" ~/.config/nvim/init.vim; } \
    || { echo "Can't link symlink neovim config"; exit 1; }

if [ -z "$(command -v brew)" ]; then
    "Please install homebrew first"
    exit 1;
fi

echo "Brew update & cleanup."
brew update && brew cleanup \
    || { echo "Need root to fix homebrew"; sudo chown -R "$(whoami)" "$(brew --prefix)/*" ; } \
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
    command -v "${PKG_NAME}" &>/dev/null || brew list "${PKG_NAME}" &>/dev/null || brew install "${PKG_NAME}" --force-bottle || exit 1
done

echo "Checking for universal-ctags"
brew list universal-ctags &>/dev/null || brew install --HEAD universal-ctags/universal-ctags/universal-ctags || exit 1

echo "Checking for Nerd Font."

ls ~/Library/Fonts/Hack\ Regular\ Nerd\ Font\ Complete\ Mono.ttf &>/dev/null \
    || curl -L https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf \
    -o ~/Library/Fonts/Hack\ Regular\ Nerd\ Font\ Complete\ Mono.ttf \
    || exit 1

echo "Checking python2 (homebrew)"
brew list python2 &>/dev/null \
    || brew install python2 \
    || { echo "Couldn't install homebrew's python2"; exit 1; }

ln -sf "$(brew --prefix python2)/bin/python2" /usr/local/bin/python2 \
    || { echo "Couldn't link python2!"; exit 1; }

ln -sf "$(brew --prefix python2)/bin/pip2" /usr/local/bin/pip2 \
    || { echo "Couldn't link pip2!"; exit 1; }

echo "Checking python3 (homebrew)"
brew list python3 &>/dev/null \
    || brew install python3 \
    || { echo "Couldn't install homebrew's python3"; exit 1; }

ln -sf "$(brew --prefix python3)/bin/python3" /usr/local/bin/python3 \
    || { echo "Couldn't link python3!"; exit 1; }

ln -sf "$(brew --prefix python3)/bin/pip3" /usr/local/bin/pip3 \
    || { echo "Couldn't link pip3!"; exit 1; }

command -v pip2 &>/dev/null || \
    { echo "Can't find pip2 command, check pip version and link it"; exit 1; }
    
command -v pip3 &>/dev/null || \
    { echo "Can't find pip3 command, check pip version and link"; exit 1; }

echo "Updating Python pip"
pip2 install -U --user pip || exit 1
pip3 install -U --user pip || exit 1

echo "Python helper packages"
pip2 install -U --user pynvim || exit 1
pip3 install -U --user pynvim || exit 1
pip3 install -U --user pylint || exit 1

echo "NeoVim PlugInstall."
if [ -f ~/.vim/plugged/cpsm/bin/cpsm_cli ]; then
    nvim --headless +PlugInstall +qa
else
    nvim --headless +PlugInstall! +qa
fi

echo "Done."
