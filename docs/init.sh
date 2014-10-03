#!/bin/sh

export PATH=$PATH:/root/python/bin
export PATH=$PATH:$EXTRA_PATH

if [[ "$#" -eq 0 ]]; then
    exec intro "$@"
elif [[ "$1" =~ ^-.* ]]; then
    # no arguments, or something that looks like an option:
    # redirect to 'intro' to show docs, etc.
    exec intro "$@"
elif [[ "$1" == "split" ]]; then
    shift
    python /split-splice-fastq/split.py "$*"
elif [[ "$1" == "splice" ]]; then
    shift
    python /split-splice-fastq/splice.py "$*"
else
    /bin/sh -c "$*"
fi
