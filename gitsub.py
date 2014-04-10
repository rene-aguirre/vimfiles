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

local_files = ['git', 'ls-files', '-oc', '--exclude-standard']
submodules = ['git', 'submodule', '--quiet', 'foreach', 'echo $path']

def list_git_files(start_dir):
    "List git files on current repo and sub-repos"
    restore_dir = os.getcwd()
    if start_dir:
        os.chdir( start_dir )

    # first print local files
    for item in subp.check_output(local_files).split('\n'):
        if item:
            print(os.path.join(start_dir, item))
 
    for dir_item in subp.check_output(submodules).split('\n'):
        if dir_item:
            list_git_files(dir_item)
            # restore dir
    os.chdir(restore_dir)


def main(arguments):
    #ignoring arguments

    try:
        list_git_files('')
    except:
        pass

if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))

