#!/usr/bin/env bash

# just in case /usr/local/bin is not in current path
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

# homebrew's python required for homebrew's finary packages (linked to)
BREW_PKGS=( python@2 python pyenv cmake neovim ripgrep boost shellcheck fzy yamllint zstd llvm swiftlint swift-format clang-format )

echo "Homebrew packages, check & install/upgrade..."
for PKG_NAME in "${BREW_PKGS[@]}"; do
    echo "Checking for ${PKG_NAME}."
    brew list "${PKG_NAME}" &>/dev/null && brew upgrade "${PKG_NAME}" || brew install "${PKG_NAME}" --force-bottle || exit 1
done

# maybe already installed (system)
BREW_PKGS=( git )

for PKG_NAME in "${BREW_PKGS[@]}"; do
    echo "Checking for ${PKG_NAME}."
    command -v "${PKG_NAME}" &>/dev/null || brew list "${PKG_NAME}" &>/dev/null && brew upgrade "${PKG_NAME}" || brew install "${PKG_NAME}" --force-bottle || exit 1
done

echo "Checking for universal-ctags"
brew list universal-ctags &>/dev/null || brew install --HEAD universal-ctags/universal-ctags/universal-ctags || exit 1

echo "Checking for Nerd Font."
ls ~/Library/Fonts/Hack\ Regular\ Nerd\ Font\ Complete\ Mono.ttf &>/dev/null \
    || curl -L https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf \
    -o ~/Library/Fonts/Hack\ Regular\ Nerd\ Font\ Complete\ Mono.ttf \
    || exit 1

if [ -x "$(command -v pyenv)" ]; then
    # checking if pyenv had installed already
    echo $PATH | grep "$(pyenv root)/shims" \
        || { echo "Need to add 'eval \$(pyenv init -)' to startup profile!"; eval "$(pyenv init -)"; }
else
    echo "pyenv not found, please re-install or fix"
    exit 1
fi

echo Installing brew packages needed to build pyenv python as framework

BREW_PKGS=( openssl readline sqlite3 xz zlib )
for PKG_NAME in "${BREW_PKGS[@]}"; do
    echo "Checking for ${PKG_NAME}."
    brew list "${PKG_NAME}" &>/dev/null && brew upgrade "${PKG_NAME}" || brew install "${PKG_NAME}" --force-bottle || exit 1
done

PYENV_VERSIONS=( 3.8.5 2.7.18 )
for PY_VER in "${PYENV_VERSIONS[@]}"; do
    pyenv versions --bare | grep -e "^${PY_VER}\$" &>/dev/null || \
        echo "Install python ${PY_VER} with pyenv" \
        env PYTHON_CONFIGURE_OPTS="--enable-framework" pyenv install "$PY_VER" \
            || { echo "Error: Couldn't install pyenv python ${PY_VER}"; exit 1; }
    pyenv versions --bare | grep -e "^${PY_VER}\$" || \
        { echo "pyenv doesn't show python ${PY_VER} is installed"; exit 1; }
done
# post install
pyenv rehash
echo "Setting pyenv default global versions"
pushd ~ && pyenv global "${PYENV_VERSIONS[@]}" && popd

# test pip installs
command -v pip2 &>/dev/null || \
    { echo "Can't find pip2 command, fix pyenv installs"; exit 1; }

command -v pip3 &>/dev/null || \
    { echo "Can't find pip3 command, fix pyenv installs"; exit 1; }

# echo "Updating Python pip"
# pip2 install -U --user pip || exit 1
# pip3 install -U --user pip || exit 1

echo "Python helper packages"
pip2 install -U --user pynvim || exit 1
PY_PKGS=( pynvim pylint python-language-server cmake-language-server hdl-checker )
for PKG_NAME in "${PY_PKGS[@]}"; do
    echo "Install/upgrade python package ${PKG_NAME}"
    pip3 install -U --user "${PKG_NAME}" || exit 1
done

echo "NeoVim PlugInstall."
if [ -f ~/.vim/plugged/cpsm/bin/cpsm_cli ]; then
    nvim --headless +PlugInstall +qa
else
    nvim --headless +PlugInstall! +qa
fi

echo "macos packages bootstrap installation completed."
