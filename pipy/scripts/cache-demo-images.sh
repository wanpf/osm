#!/bin/bash

set -euo pipefail

if [ -z "$1" ]; then
  echo "Error: expected one argument OSM_HOME"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Error: expected one argument OS_ARCH"
  exit 1
fi

OSM_HOME=$1
BUILD_ARCH=$2

if [[ "${BUILD_ARCH}" == "amd64" ]]; then
  docker pull docker.io/library/mysql:5.6
  docker pull docker.io/curlimages/curl:latest

  docker tag docker.io/library/mysql:5.6 localhost:5000/library/mysql:5.6
  docker tag docker.io/curlimages/curl:latest localhost:5000/curlimages/curl:latest

  docker push localhost:5000/library/mysql:5.6
  docker push localhost:5000/curlimages/curl:latest

  sed -i 's#image: mysql:5.6#image: localhost:5000/library/mysql:5.6#g' ${OSM_HOME}/demo/deploy-mysql.sh
  sed -i 's#image: curlimages/curl#image: localhost:5000/curlimages/curl#g' ${OSM_HOME}/demo/multicluster-fault-injection.sh
fi

if [[ "${BUILD_ARCH}" == "arm64" ]]; then
  docker pull docker.io/devilbox/mysql:mysql-8.0
  docker pull docker.io/curlimages/curl:latest

  docker tag docker.io/devilbox/mysql:mysql-8.0 localhost:5000/devilbox/mysql:mysql-8.0
  docker tag docker.io/curlimages/curl:latest localhost:5000/curlimages/curl:latest

  docker push localhost:5000/devilbox/mysql:mysql-8.0
  docker push localhost:5000/curlimages/curl:latest

  sed -i 's# devilbox/mysql:mysql-8.0# localhost:5000/devilbox/mysql:mysql-8.0#g' ${OSM_HOME}/demo/deploy-mysql.sh
  sed -i 's# curlimages/curl# localhost:5000/curlimages/curl#g' ${OSM_HOME}/demo/multicluster-fault-injection.sh
fi