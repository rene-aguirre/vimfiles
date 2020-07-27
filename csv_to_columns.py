#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Convert CSV input to text columns
"""

import sys
import argparse
import csv

__version__ = "0.0.1"

def get_arg_parser():
    """Create CLI Argument parser instance
    """
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('-i', '--infile', type=argparse.FileType('r'), default=sys.stdin,
                        help="Input file (default stdin)")
    parser.add_argument('-o', '--outfile', type=argparse.FileType('w'), default=sys.stdout,
                        help="Target output file")
    parser.add_argument('-a', '--abacad', help='An option')
    parser.add_argument('-b', '--blabacab', help="Another option")

    return parser

def main(arguments):
    """CLI standalone entry point"""
    parser = get_arg_parser()
    args = parser.parse_args(arguments)

    # two passes for for max column widths next to format
    widths = []
    rows = []
    reader = csv.reader(args.infile, quotechar='"')
    for row in reader:
        if len(widths) < len(row):
            widths += [0,] * (len(row) - len(widths))
        widths = [max(a, b) for a, b in zip(map(len, row), widths)]
        rows.append(row)
    col_fmts = ["{{: <{}}}".format(w) for w in widths]
    for row in rows:
        line_fmt = ' '.join(col_fmts[:len(row)])
        args.outfile.write(line_fmt.format(*row))
        args.outfile.write('\n')

if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
