Installation
============

Disclaimer
----------

Vim is not easy, as a matter of fact if you spend few minutes a day using your
current text/code editor I would not recommend it, the learning curve might
not be worth it.

This instructions are intended to facilitate installation on Windows, with my
'preferred' configurations, feel feel to clone it and tweak it once you feel
comfortable (read the comments, check Vim's help).

If you run into any issue... GIYF ;-)

Requirements
------------

    * VIM, an easy starting point is the standard distribution from vim.org

    * git, use msysgit on Windows.

    * Powerline (Vim plugin) pathed DejaVu Sans Mono font: https://github.com/Lokaltog/vim-powerline/wiki/Patched-fonts

As the vimrc configuration file carries git managed plugin configurations
(using the Vundle pluging), this repository has to be in a separate location
from the plugins folder, the idea is to use different paths carried in the
default vim runtime path configuration. 

If the suggested folders don't work, please confirm the runtime path setting
issuing a `:set runtimepath` command from vim.

I'm using windows in my setup.

For Windows, find our where your $HOME folder is, for vim this is your `~/.` (tilde)
folder, from vim, so open or browse to the $HOME folder and find out where it is::

    :e $HOME
    :cd

This issually maps to the `%USERPROFILE` Windows environment variables.

First install Vundle vim plugin, this will facilitate to replicate the full
setup one the new vim configuration is installed::

    git clone https://github.com/gmarik/vundle.git .vim/bundle/vundle 

Now, clone this repo into the vimfiles (or any other `~/.` mapped runtime path
location, preferably not `.vim`), from the command line::

    cd %USERHOME%
    git clone https://github.com/rene-aguirre/vimfiles.git vimfiles

A new `vimfiles` folder would be created, with the contents of this repo. Now copy the provided `_vimrc` file to the `$HOME` folder::

    cd vimfiles
    copy _vimrc ..

We are ready, but need to pull all the configured plugins, this is managed by
Bundle, so re-start Vim, and issue this command::

    :BundleInstall!

Git will run in the background, pulling the code, hopefully the Bundle update
buffer will be shown without any error (check the Bundle pluging repo if you
had any error).

Re-start Vim to confirm there are not any errors at start up this time, you're ready to go.

