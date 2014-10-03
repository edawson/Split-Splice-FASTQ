set -x

# File to split
INFILE="${infile}"

echo "${INFILE}" >> .agave.archive

# Number of slices
SLICES="${slices}"

# Max number of records per slice
RECORDS="${records}"

# The input file is already here. We check to see if we need to unpack
# it using the flag parameter `unpackInputs` passed in.
if [ -n "${unpackInputs}" ]; then
	infile_extension="${INFILE##*.}"

	if [ "$infile_extension" == 'zip' ]; then
	  unzip "$INFILE"
	elif [ "$infile_extension" == 'tar' ]; then
	  tar xf "$INFILE"
	elif [ "$infile_extension" == 'gz' ] || [ "$infile_extension" == 'tgz' ]; then
	  tar xzf "$INFILE"
	elif [ "$infile_extension" == 'bz2' ]; then
	  bunzip "$INFILE"
	elif [ "$infile_extension" == 'rar' ]; then
	  unrar "$INFILE"
	else
		echo "Unable to unpack input file $INFILE due to unknown compression extension, ${infile_extension}. Terminating job ${AGAVE_JOB_ID}" >&2
	  ${AGAVE_JOB_CALLBACK_FAILURE}
		exit
	fi
fi

DOCKER_IMAGE="agaveapi/split-splice-fastq"

if [ -e "Dockerfile" ]; then

  # replace the given image with the job id so we know we execute the correct container
  DOCKER_IMAGE=${AGAVE_JOB_ID}

	time -p docker build -rm -t "$DOCKER_IMAGE" .

	# Fail the job if the build fails
	if [ ! $? ]; then
		echo "Failed to build Dockerfile. Terminating job ${AGAVE_JOB_ID}" >&2
		${AGAVE_JOB_CALLBACK_FAILURE}
		exit
	fi

fi

# Run the container in docker, mounting the current job directory as /scratch in the container
# Note that here the docker container image must exist for the container to run. If it was
# not built using a passed in Dockerfile, then it will be downloaded here prior to
# invocation. Also note that all output is written to the mounted directory. This allows
# Agave to stage out the data after running.

docker run -i -t -v `pwd`:/data -w /data $DOCKER_IMAGE split -i $INFILE $SLICES $RECORDS 2>> ${AGAVE_JOB_NAME}.err

if [ ! $? ]; then
	echo "Docker process exited with an error status." >&2
	${AGAVE_JOB_CALLBACK_FAILURE}
	exit
fi

# Good practice would suggest that you clean up your image after running. For throughput
# you may want to leave it in place. iPlant's docker servers will clean up after themselves
# using a purge policy based on size, demand, and utilization.

#docker rmi $DOCKER_IMAGE
