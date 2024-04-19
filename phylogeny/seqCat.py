#!/usr/bin/env python3
#export PATH=/work/LAS/jfw-lab/ehsan/bin/biopython/:$PATH

#run as python script.py -l INPUT.LIST -o OUTPUT.nex

import sys
import argparse
from Bio.Nexus import Nexus

def main():
    # Create an argument parser
    parser = argparse.ArgumentParser(description="Combine Nexus files")

    # Add command-line arguments for input and output files
    parser.add_argument("-l", "--listfile", required=True, help="Input file containing a list of file names")
    parser.add_argument("-o", "--outputfile", required=True, help="Output Nexus file")

    # Parse the command-line arguments
    args = parser.parse_args()

    # Read the list of file names from the input file
    with open(args.listfile, "r") as file:
        file_list = [line.strip() for line in file]

    nexi = [(fname, Nexus.Nexus(fname)) for fname in file_list]

    combined = Nexus.combine(nexi)

    # Write the combined data to the output file
    combined.write_nexus_data(filename=args.outputfile)

if __name__ == "__main__":
    main()

