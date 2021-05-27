#!/bin/sh

docker-compose pull
docker-compose stop
echo "backup..."
rm ./backup-*
tar --exclude='./backup*' -zcf ./backup-`date +%Y%m%d_%H%M%S`.tgz .
docker-compose up -d

