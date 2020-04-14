#!/bin/bash
#

echo "Checking if we use podman engine"
if [ -f /usr/bin/podman ]; then
   echo "Use Podman"
   docker_bin="podman"
else
   echo "Use Docker"
   docker_bin="docker"
fi

echo "Stopping reprophylo container"
sudo $docker_bin rm -f rpnotebook