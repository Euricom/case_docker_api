#!/bin/bash
# Ensure exit codes other than 0 fail the build
set -e

# CircleCI artifacts folder (sort of output folder)
# echo $CIRCLE_ARTIFACTS

# Get version from package.json
VERSION=$(node server/extractversion.js)
echo $VERSION

APP_NAME=$2-$1
echo 'Heroku app name='
echo $APP_NAME

docker build -t $2 .
docker save -o $CIRCLE_ARTIFACTS/$2.tar $2

# Docker Hub
docker login
docker tag $2 $3/$2:$VERSION
docker push $3/case-docker-api:$VERSION

# Heroku
docker logout
docker login --email=_ --username=_ --password=$HEROKU_API_KEY registry.heroku.com
docker tag $2 registry.heroku.com/$APP_NAME/web
docker push registry.heroku.com/$APP_NAME/web