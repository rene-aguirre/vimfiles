#!/usr/bin/env bash

verbose() {
    true
}

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

echo "Checking Homebrew packages..."
# package installation cache
BP="$(brew list --formula -1)"
# check if brew has package
brew_has() {
    grep -e "^$1$" &>/dev/null <<<"$BP"
}

# package outdated cache
BO="$(brew outdated)"
# check if package is outdated
brew_outdated() {
    grep -e "^$1 " &>/dev/null <<<"$BO"
}

bottle_disabled() {
    PKG="$1"
    brew info --json=v1 "${PKG}" | jq '.[0].bottle_disabled'
}

# install (or upgrades) package if required
brew_check_install() {
    PKG="$1"
    PKG_FORCE_BOTTLE=( "$1" )
    if [ "$PKG" != "jq" ]; then
        BOTTLE_DISABLED="$(bottle_disabled "$1")"
        verbose && echo "$1 bottle disabled = '$BOTTLE_DISABLED'"
        if [ "${BOTTLE_DISABLED}" = "false" ]; then
            PKG_FORCE_BOTTLE+=( "--force-bottle" )
        fi
    fi
    echo "Checking for ${PKG}."
    if brew_has "${PKG}"; then
        verbose && echo "  - ${PKG} found."
        if brew_outdated "${PKG}"; then
            echo "  - ${PKG} is outdated, upgrading..."
            ( brew upgrade "${PKG_FORCE_BOTTLE[@]}" && echo "  - ${PKG} upgraded." ) || \
                { \
                    echo "Can't upgrade '${PKG}'. Fix manually.";
                    false;
                    return;
                }
        else
            verbose && echo "  - ${PKG} Up to date"
        fi
    else
        verbose && echo "  - Installing ${PKG}..."
        brew install "${PKG_FORCE_BOTTLE[@]}" || \
            {
                echo "Can't Install '${PKG}'. Fix manually.";
                false;
                return;
            }
        verbose && echo "  - ${PKG} has been installed."
    fi
    true
}

echo "Brew update & cleanup."
brew update && brew cleanup \
    || { echo "Need root to fix homebrew"; sudo chown -R "$(whoami)" "$(brew --prefix)/*" ; } \
    || brew update && brew cleanup \
    || exit 1

# homebrew's python required for homebrew's finary packages (linked to)
BREW_PKGS=( jq python@2 python pyenv cmake neovim ripgrep boost shellcheck fzy yamllint zstd llvm swiftlint swift-format clang-format yarn )

echo "Homebrew packages, check & install/upgrade..."
for PKG_NAME in "${BREW_PKGS[@]}"; do
    brew_check_install "${PKG_NAME}" || exit 1
done

# maybe already installed (keep system's)
BREW_PKGS=( git )

for PKG_NAME in "${BREW_PKGS[@]}"; do
    echo "Checking for ${PKG_NAME}."
    command -v "${PKG_NAME}" &>/dev/null || brew_check_install "${PKG_NAME}" || exit 1
done

echo "Checking for universal-ctags"
brew_has universal-ctags || brew install --HEAD universal-ctags/universal-ctags/universal-ctags || exit 1

echo "Checking for Nerd Font."
ls ~/Library/Fonts/Hack\ Regular\ Nerd\ Font\ Complete\ Mono.ttf &>/dev/null \
    || curl -L https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf \
    -o ~/Library/Fonts/Hack\ Regular\ Nerd\ Font\ Complete\ Mono.ttf \
    || exit 1

if [ -x "$(command -v pyenv)" ]; then
    # checking if pyenv had installed already
    grep "$(pyenv root)/shims" <<< "$PATH" \
        || { echo "Need to add 'eval \$(pyenv init -)' to startup profile!"; eval "$(pyenv init -)"; }
else
    echo "pyenv not found, please re-install or fix"
    exit 1
fi

echo Installing brew packages needed to build pyenv python as framework

BREW_PKGS=( openssl@1.1 readline sqlite xz zlib bzip2 )
for PKG_NAME in "${BREW_PKGS[@]}"; do
    brew_check_install "${PKG_NAME}" || exit 1
done

echo forcing homebrew zlib
export LDFLAGS="-L$(brew --prefix zlib)/lib"
export CPPFLAGS="-I$(brew --prefix zlib)/include"
export PKG_CONFIG_PATH="$(brew --prefix zlib)/lib/pkgconfig"

verbose && echo "LDFLAGS=$LDFLAGS"
verbose && echo "CPPFLAGS=$CPPFLAGS"
verbose && echo "PKG_CONFIG_PATH=$PKG_CONFIG_PATH"

PYENV_VERSIONS=( 3.8.5 2.7.18 )
for PY_VER in "${PYENV_VERSIONS[@]}"; do
    ( pyenv versions --bare | grep -e "^${PY_VER}\$" &>/dev/null ) || \
        (
            echo "Installing python ${PY_VER} with pyenv" && \
            env PYTHON_CONFIGURE_OPTS="--enable-framework" pyenv install "$PY_VER"
        ) || \
        {
            echo "Error: Couldn't install pyenv python ${PY_VER}";
            exit 1;
        }
    pyenv versions --bare | grep -e "^${PY_VER}\$" || \
        { echo "pyenv doesn't show python ${PY_VER} is installed"; exit 1; }
done
# post install
pyenv rehash
echo "Setting pyenv default global versions"
pushd ~ && pyenv global "${PYENV_VERSIONS[@]}" && popd || exit 1

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
