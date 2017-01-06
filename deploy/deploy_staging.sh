#!/bin/bash
# Ensure exit codes other than 0 fail the build
set -e

# CircleCI artifacts folder (sort of output folder)
echo $CIRCLE_ARTIFACTS

# Get version from package.json
VERSION=$(node server/extractversion.js)
echo $VERSION

REMOTE=wimvandenrul
NAME=example123

# Build docker image
docker build -t example123 .

# TODO Save docker image to artifacts folder in Circle CI
# docker save -o $CIRCLE_ARTIFACTS/example.tar $APP:$TAG

# Tag docker image
docker tag $NAME $REMOTE/$NAME:$VERSION
# Push to Docker Hub
docker push $REMOTE/$NAME:$VERSION
# Tag docker image
docker tag $NAME $REMOTE/$NAME:latest
# Push to Docker Hub
docker push $REMOTE/$NAME:latest

# Login to Heroku repository
docker login --email=_ --username=_ --password=$HEROKU_API_KEY registry.heroku.com

# Deploy to Heroku
REMOTE=registry.heroku.com
NAME=example123

docker tag $NAME registry.heroku.com/example123-staging/web
docker push registry.heroku.com/example123-staging/web