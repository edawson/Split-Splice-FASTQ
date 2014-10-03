#!/bin/bash

set -x

# File to split
export infile="100k_fasta.fa"

# Number of slices
export slices="-split 5"

# Max number of records per slice
export records=""

# data isn't compressed
export unpackInputs=

exec ../app/wrapper.sh
