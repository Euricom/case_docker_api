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

# Save docker image to artifacts folder in Circle CI
docker save -o $CIRCLE_ARTIFACTS/example123.tar $NAME

# Login to Docker Hub
docker login --email=$DOCKER_EMAIL --username=$DOCKER_LOGIN --password=$DOCKER_PASSWORD

echo "Successful login to Docker Hub"

# Tag docker image
docker tag $NAME $REMOTE/$NAME:$VERSION
# Push to Docker Hub
docker push $REMOTE/$NAME:$VERSION
# Tag docker image
docker tag $NAME $REMOTE/$NAME:latest
# Push to Docker Hub
docker push $REMOTE/$NAME:latest

echo "Successfully pushed docker images to Docker Hub"

docker logout

# Login to Heroku repository
docker login --email=_ --username=_ --password=$HEROKU_API_KEY registry.heroku.com
echo "Successful login to Heroku"

# Deploy to Heroku
REMOTE=registry.heroku.com

docker tag $NAME $REMOTE/example123-staging/web
docker push $REMOTE/example123-staging/web