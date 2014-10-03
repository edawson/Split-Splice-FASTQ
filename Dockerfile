FROM waltermoreira/base-sci-app

MAINTAINER dooley@tacc.utexas.edu

ENV _APP split-splice-fastq
ENV _VERSION 0.1.0
ENV _LICENSE BSD 2-Clause
ENV _AUTHOR eric@tacc.utexas.edu

RUN pip install argparse

ADD docs/intro.txt /docs/split-splice-fastq/intro.txt
ADD docs/usage.txt /docs/split-splice-fastq/usage.txt
ADD docs/examples.txt /docs/split-splice-fastq/examples.txt

ADD docs/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

RUN mkdir /split-splice-fastq
ADD bin/split.py /split-splice-fastq/split.py
ADD bin/splice.py /split-splice-fastq/splice.py
ADD test/100k_fasta.fa /split-splice-fastq/100k_fasta.fa

WORKDIR /data
VOLUME /data
CMD []
