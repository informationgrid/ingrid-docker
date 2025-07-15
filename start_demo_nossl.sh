#!/bin/bash

UNAME=$(which uname)
GREP=$(which grep)

printf "Configure sample .env\n"
cp .env.sample .env

printf "Set Host to ingrid.localhost.\n"
export HOST=ingrid.localhost

printf "Create database folder.\n"

mkdir -p _data/postgres-db

printf "Set permissions for default user.\n"
sudo chown -R 1000:1000 ./_data

printf "Copy initial sample webmapclient data.\n"
cp -r map/WebmapClientData.test/* map/WebmapClientData

printf "Increase memory for elastic.\n"
if [[ $($UNAME -a | $GREP -i linux) ]]; then
sysctl vm.max_map_count
sudo sysctl -w vm.max_map_count=262144
fi

if [[ $($UNAME -a | $GREP -i darwin) ]] then
printf "Can't run these lines on a mac. Skipping.\n"
fi

printf "The installation uses docker images from a non-public docker registry.\n You can also build your own images by following the instructions in the specific ingrid repositories.\n"
sudo docker login -u readonly -p readonly docker-registry.wemove.com &> /dev/null # password "readonly"
sudo docker compose up -d

printf "First time boot requires around 60 seconds to be ready.\n\n\n"
sleep 60
sudo docker compose ps
exit 0
