## Disclaimer

If you run into any issue: GIYF ;-)


## Requirements

 * NoeVim or Vim with working Python2/Python3 (use `:checkhealth` on NeoVim to validate).
   Preferably this has to be a runtime path exposed binary, with working pip2/pip3 commands.
   Don't use virtual envs.

 * git, cmake, ripgrep

 * (Hack Nerd font)[https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack/Regular/complete]

 * cmake

 * ripgrep


## Mac OS X installation

 * Install XCode command line tools (if you can compile and run C/C++ you might be fine).

 * Homebrew install python2 and python3 packages. If `which python` doesn't show `/usr/local/bin/python`
   fix your path (`/usr/local/bin` in front of current python path).

 * Homebrew install git, cmake, ripgrep and neovim/vim (or both).

 * Download and install Hack Nerd font (link above)

 * Symlink this repository's `vimrc` to `~/.config/nvim/init.vim` for NeoVim

 * OS X already has a vim, only symlink `vimrc` to `~/.vimrc` if you had
   install Homebrew's vim. Using system's vim migth need more tweaks as
   it depends on system python. I don't like installing packages in
   the system python package, hence using Homebrew's python packages.

 * Run `nvim`, ignore the errors for now, type `:PlugInstall` to install
   plugins.

 * Restart `nvim`. All should be fine now.


### Other OS

Some plugins need to build a shared library (or DLL), if this is not possible
disable the offending plugins.

Requirements are equivalent. The actual target `vimrc` path might change.

If the suggested folders don't work, please confirm the runtime path setting
show in `:version` or checking the output of `:set runtimepath` command from nvim/vim.

## Plugins

This configuration uses (vim-plug)[https://github.com/junegunn/vim-plug] to manage plug-ins
installations and upgrades.

