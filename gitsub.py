#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
    List files across all git submodules, starting from top level dir

"""


from __future__ import print_function
import os
import subprocess as subp

__version__ = "0.0.1"
__author__ = "Rene Aguirre"

DEBUG_DIRS = False
DIRECT_ACCESS = True

CMD_LS_FILES = ['git', 'ls-files', '-oc', '--exclude-standard',
                '--directory', '--no-empty-directory']
CMD_LS_SUBS = ['git', 'submodule', '--quiet', 'foreach', 'echo $path']
CMD_GIT_SUBS = ['git', 'config', '-f', '.gitmodules', '--get-regexp', r'^submodule\..*\.path$']

def list_git_files(prefix, start_dir):
    "List git files on current repo and sub-repos"
    restore_dir = os.getcwd()
    if start_dir:
        os.chdir(start_dir)

    full_prefix = os.path.join(prefix, start_dir)
    # first print local files
    if not DEBUG_DIRS:
        for item in subp.check_output(CMD_LS_FILES, universal_newlines=True).split('\n'):
            if item:
                print(os.path.normpath(os.path.join(full_prefix, item)))
    else:
        print(full_prefix)

    if os.path.exists('.gitmodules'):
        if DIRECT_ACCESS:
            for key_value in subp.check_output(CMD_GIT_SUBS, universal_newlines=True).split('\n'):
                dir_item = " ".join(key_value.split(' ')[1:])
                if dir_item:
                    list_git_files(full_prefix, dir_item)
        else:
            for dir_item in subp.check_output(CMD_LS_SUBS, universal_newlines=True).split('\n'):
                if dir_item:
                    list_git_files(full_prefix, dir_item)
    # restore dir
    os.chdir(restore_dir)

if __name__ == '__main__':
    list_git_files('', '')

