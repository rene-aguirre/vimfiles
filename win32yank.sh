#!/bin/bash
/mnt/c/tools/neovim/Neovim/bin/win32yank.exe "$@" 2> >(sed -e '1h;2,$H;$!d;g' -r -e 's/Unable to translate[^\n]*\n//' 1>&2)
