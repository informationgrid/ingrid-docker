#!/bin/bash
cp .env.sample .env
export HOST=ingrid.localhost
mkdir -p _data/postgres-db
sudo chown -R 1000:1000 ./_data
# copy initial sample webmapclient data
cp -r portal/WebmapClientData.test/* _data/portal/WebmapClientData
# increase memory for elastic; if you don't do this, elastic won't even boot because it checks for a sane value
# don't run these lines if you're on mac

sysctl vm.max_map_count
sudo sysctl -w vm.max_map_count=262144

# The installation uses docker images from a non-public docker registry. You can also build your own images by following the instructions in the specific ingrid repositories.
sudo docker login -u readonly -p readonly docker-registry.wemove.com # password "readonly"
sudo docker compose up -d
sudo docker compose ps
exit 0
