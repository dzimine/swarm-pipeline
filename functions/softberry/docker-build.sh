#!/bin/bash
# Build a chain of Docker images

set -e

REGISTRY=${DOCKER_REGISTRY:-'pregistry:5000'}
echo "Using registry $REGISTRY"
echo ""

# Order matters, so don't be too smart :)
#    IMAGES=$(ls Dockerfile.* | awk -F . '{ print $NF }')
IMAGES=( blast_base sb_base fgenesb blast_fb fgenesb_out )

echo ${IMAGES[@]}

for i in "${IMAGES[@]}"; do
  echo "Build image for $i ..."
  docker build -t sb/$i -t $REGISTRY/$i -f $i.Dockerfile .
  echo "Pushing $i to local registry ..."
  docker push $REGISTRY/$i
done

echo "Building image for cgview ..."
docker build -t sb/cgview -t $REGISTRY/cgview -f ./Fgenesb_CGView/Dockerfile Fgenesb_CGView/
echo "Building cgview to local registry ..."
docker push $REGISTRY/cgview

