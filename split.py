__author__ = 'Eric T Dawson'
import sys
import re
import os
import argparse
import shutil
import math

fastq_extensions = ["fq", "fastq"]
fasta_extensions = ["fa", "fas", "fasta"]


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", dest="infile", type=str)
    args = parser.parse_args()
    return args


def count_records(filename, isFastq):
    count = 0
    iden = "@" if isFastq else ">"
    with open(filename, "r") as infile:
        for line in infile:
            if line.startswith(iden):
                count += 1
    return count


def process_fasta_by_splits()

def process_fasta(filename, isFastq, num_records=1000):
    split_number = 1
    basename = os.path.basename(filename)
    extension = basename.split(".")[-1]
    records = []
    tmp_dir = ""
    # shutil.rmtree(tmp_dir)
    # os.mkdir(tmp_dir)
    iden = "@" if isFastq else ">"
    original_records_count = 0
    with open(filename, "r") as infile:
        count = 0
        for line in infile:
            is_new = line.startswith(iden)
            if is_new:
                count += 1
            if count >= num_records:
                cname = "".join(basename.split(".")[:-1]) + "_split_" + str(split_number) + "." + extension
                with open(cname, "w") as outfile:
                    for record in records:
                        outfile.write(record)
                records = []
                original_records_count += count
                count = 0
                split_number += 1
            records.append(line)
    return original_records_count


def split_file(filename):
    basename = os.path.basename(filename)
    file_path = os.path.abspath(filename)
    isFastq = basename.split(".")[-1] in fastq_extensions
    if not isFastq and not basename.split(".")[-1] in fasta_extensions:
        raise ValueError("The file provided has neither a fasta nor fastq extension.")

    ## TODO use os.getsize() to intelligently, rapidly esimate line count
    ## TODO CHECK THIS VALUE
    # x = math.ceil(float(num_records) / 10.0)
    x = process_fasta(filename, isFastq, splits=10)
    return x


def main():
    args = parse_args()
    filename = args.infile
    basename = os.path.basename(filename)

    isFastq = basename.split(".")[-1] in fastq_extensions
    if not isFastq and not basename.split(".")[-1] in fasta_extensions:
        raise ValueError("The file provided has neither a fasta nor fastq extension.")

    num_records = count_records(filename, isFastq)
    process_fasta(filename, 1000, isFastq)


if __name__ == "__main__":
    main()