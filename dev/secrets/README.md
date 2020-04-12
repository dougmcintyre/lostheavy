# Secrets

I'm using env vars to get/set secret values. Its not a good idea to make your secrets public, see .gitignore in secrets/ to see how I've kept them from being committed.

The pw.sh file:
```sh
cat secrets/pw.sh
export POSTGRES_PASSWORD="Letmein123"
```

Used in the docker run command like:
```sh
source pw.sh

docker run --name lostheavy-db -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD -d -p 5432:5432 lostheavy-db:12
```
