#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import subprocess as subp

"""
    List files across all git submodules, starting from top level dir

"""

__version__ = "0.0.1"
__author__  = "Rene Aguirre"

DEBUG_DIRS    = False
DIRECT_ACCESS = True

cmd_ls_files = ['git', 'ls-files', '-oc', '--exclude-standard']
cmd_ls_subs  = ['git', 'submodule', '--quiet', 'foreach', 'echo $path']
cmd_git_subs = ['git', 'config', '-f', '.gitmodules', '--get-regexp', '^submodule\..*\.path$']

def list_git_files(prefix, start_dir):
    "List git files on current repo and sub-repos"
    restore_dir = os.getcwd()
    if start_dir:
        os.chdir( start_dir )

    full_prefix = os.path.join(prefix, start_dir)
    # first print local files
    if not DEBUG_DIRS:
        for item in subp.check_output(cmd_ls_files).split('\n'):
            if item:
                print(os.path.normpath(os.path.join(full_prefix, item)))
    else:
        print(full_prefix)
 
    if os.path.exists('.gitmodules'):
        if DIRECT_ACCESS:
            for key_value in subp.check_output(cmd_git_subs).split('\n'):
                dir_item = " ".join( key_value.split(' ')[1:] )
                if dir_item:
                    list_git_files(full_prefix, dir_item)
        else:
            for dir_item in subp.check_output(cmd_ls_subs).split('\n'):
                if dir_item:
                    list_git_files(full_prefix, dir_item)
    # restore dir
    os.chdir(restore_dir)

def main(arguments):
    #ignoring arguments

    try:
        list_git_files('', '')
    except:
        pass

if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))

