"""Plot TSV files

Usage:
  plot_tsv.py twocol [options] <file> <col-1> <col-2>
  plot_tsv.py (-h | --help)
  plot_tsv.py --version

Options:
  -h --help                Show this screen.
  --version                Show version.
  -o --output-file=<file>  Output file name [default: plot.pdf]
  -s --show                Show plot in window.
"""

from docopt import docopt
import pandas as pd
import matplotlib.pyplot as plt

def parse_header(file):
    with open(file, "r") as f:
        for line in f:
            if line.startswith("#"):
                header = line
            else:
                break 

    return header[1:].strip().split()

def do_twocol(args):
    file = args["<file>"]
    col_1 = int(args["<col-1>"])
    col_2 = int(args["<col-2>"])

    header = parse_header(file)

    data = pd.read_csv(
        file,
        sep="\\s+",
        comment="#",
        names=header
    )

    col_a = data[header[col_1]]
    col_b = data[header[col_2]]

    plt.plot(col_a, col_b)
    
    if args["--show"]:
        plt.show()
    else:
        plt.savefig(args["--output-file"])

def main(args):
    if args["twocol"]:
        do_twocol(args)

if __name__ == '__main__':
    args = docopt(__doc__, version="Plot TSV 1.0")
    main(args)
