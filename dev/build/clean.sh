#!/bin/bash

docker container stop lostheavy-db
docker container rm lostheavy-db
docker image rm postgres-uuid:12
docker image rm lostheavy-db:12
