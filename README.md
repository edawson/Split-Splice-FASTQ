# Split-Splice-Fastq

This is a simple python2.7 script for splitting a fasta file into two or more smaller files for processing by BWA. 


## Docker

A dockerfile is included to build this app as an [Agave Science App](https://github.com/waltermoreira/tacc-sci-apps). 

	$ docker build -rm -t split-splice-fastq .
	
You can also download this image from the Docker central repository
	
	$ docker pull agaveapi/split-splice-fastq

## Usage

Usage information is built into all [Agave Science App](https://github.com/waltermoreira/tacc-sci-apps) images. Simply run the container with the `-h` or no arguments.

	$ docker run -it split-splice-fastq -h

