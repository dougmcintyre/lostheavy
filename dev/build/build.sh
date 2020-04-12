#!/bin/bash
source $(dirname $0)/./secrets/postgres.sh

docker build --tag postgres-uuid:12 $(dirname $0)/../../docker-images/postgres-uuid
docker build --tag lostheavy-db:12 $(dirname $0)/../../docker-images/lostheavy-db
docker run --name lostheavy-db -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD -d -p 5432:5432 lostheavy-db:12

echo $POSTGRES_PW