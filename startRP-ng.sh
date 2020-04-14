#!/bin/bash
#

host_port="443"

if [ $# -eq 2 ] && [ $2 != "--xt" ]; then
    echo "Ignoring $2. Did you mean --xt to block tutorials? ctrl+c to abort"
fi
if [ $# -eq 0 ]; then
    echo "startRP takes a path to your work dir and an optional --xt flag to supress tutorial downloads"
    exit
fi

echo " -------ReproPhylo------- "
echo "   THINGS TO NOTE"
echo " -------------------------"
echo " Ideas fom  https://github.com/szitenberg"
echo ""
echo "1. Little changes for use https port instead 8888"


sleep 6
echo
#
echo "checking if path exists: $1"
if [ -d $1 ]; then
   echo "Already exists"
else
   echo "Path was not found, creating."
   mkdir $1
fi
echo

echo "Checking if we use podman engine"
if [ -f /usr/bin/podman ]; then
   echo "Use Podman"
   docker_bin="podman"
else
   echo "Use Docker"
   docker_bin="docker"
fi

#
echo "allowing access to x server with xhost +local:root"
xhost +local:root
echo
#
if [ -d $1/Tutorial_files ]; then
    echo "Tutorial_files exists in $1"
    echo
elif [ $2 = "--xt" ]; then
    echo "Tutorial files opt out"
    echo
elif [ $# -eq 2 ] && [ $2 != "--xt" ] || [ $# -eq 1 ]; then
    echo "Putting tutorial files in $1"
    wget -c  https://github.com/HullUni-bioinformatics/ReproPhylo/archive/master.zip
    unzip -qq master.zip
    cd ReproPhylo-master
    cp -r Tutorial_files $1
    cd ..
    rm -r ReproPhylo-master
    rm master.zip
    echo "Tutorial files are in $1"
    echo
fi
echo "starting reprophylo container"
#sudo docker run --net=host --name rpnotebook -d -p 8888:8888 -e "PASSWORD=password" -v /tmp/.X11-unix:/tmp/.X11-unix:ro -v $1:/notebooks -e DISPLAY=$DISPLAY szitenberg/reprophylo /notebook.sh
sudo $docker_bin run --name rpnotebook -d -p $host_port:8888 -e "PASSWORD=password" -v /tmp/.X11-unix:/tmp/.X11-unix:ro -v $1:/notebooks -e DISPLAY=$DISPLAY szitenberg/reprophylo /notebook.sh
echo
echo "Jupyter login page is running in localhost:$host_port"
echo "Starting default browser"
echo
sleep 2
xdg-open https://localhost:$host_port