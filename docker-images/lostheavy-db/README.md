# Docker image of Postgresql v12 with UUID support

Dump existing lostheavy data
```sh
docker exec lostheavy-db pg_dump -U postgres --format custom lostheavy > "dump.pgdata"
```
