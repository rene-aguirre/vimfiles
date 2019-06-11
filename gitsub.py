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

CMD_RG_LS_FILES = ['rg', '--color=never', '--no-messages', '--files']

CMD_GIT_LS_FILES = ['git', 'ls-files', '-oc', '--exclude-standard', '--directory', '--no-empty-directory']
# CMD_GIT_LS_SUBS  = ['git', 'submodule', '--quiet', 'foreach', 'echo $path']
CMD_GIT_SUBS     = ['git', 'config', '-f', '.gitmodules', '--get-regexp', r'^submodule\..*\.path$']

def list_files(prefix, start_dir, cmd_ls_files, cmd_subs):
    "List git files on current repo and sub-repos"
    restore_dir = os.getcwd()
    if start_dir:
        os.chdir(start_dir)

    full_prefix = os.path.join(prefix, start_dir)
    # first print local files
    try:
        for item in subp.check_output(cmd_ls_files, universal_newlines=True).split('\n'):
            if item:
                print(os.path.normpath(os.path.join(full_prefix, item)))
    except subp.CalledProcessError as e:
        pass

    if cmd_subs and os.path.exists('.gitmodules'):
        try:
            for key_value in subp.check_output(cmd_subs, universal_newlines=True).split('\n'):
                dir_item = " ".join(key_value.split(' ')[1:])
                if dir_item:
                    list_files(full_prefix, dir_item, cmd_ls_files, cmd_subs)
        except subp.CalledProcessError as e:
            pass

    if os.path.exists('../.repo/project.list'):
        # assumption: single top level nested repo
        this_dir = os.path.abspath('.')
        with open('../.repo/project.list') as f:
            for line in f:
                dir_name = os.path.join('../', line.strip())
                if os.path.samefile(this_dir, dir_name):
                    continue
                if not os.path.exists(dir_name):
                    continue
                dir_name = os.path.relpath(dir_name, this_dir)
                list_files(prefix, dir_name, cmd_ls_files, cmd_subs)


    # restore dir
    os.chdir(restore_dir)

if __name__ == '__main__':
    import sys
    if '--rg' in sys.argv:
        list_files('', '', CMD_RG_LS_FILES, None)
    else:
        list_files('', '', CMD_GIT_LS_FILES, CMD_GIT_SUBS)

