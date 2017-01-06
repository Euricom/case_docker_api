#!/bin/bash
# Ensure exit codes other than 0 fail the build
set -e

# CircleCI artifacts folder (sort of output folder)
echo $CIRCLE_ARTIFACTS

# Get version from package.json
VERSION=$(node server/extractversion.js)
echo $VERSION

# Create TAG name (attach version)
APP="registry.heroku.com/example123-dev"
TAG=$VERSION
echo $APP:$TAG

# Build docker image
docker build -t $APP:$TAG .
# Save docker image to artifacts folder in Circle CI
docker save -o $CIRCLE_ARTIFACTS/example.tar $APP:$TAG
# Login to Heroku repository
docker login --email=_ --username=_ --password=$HEROKU_API_KEY registry.heroku.com
# Push the docker image (deploy to Heroku)
docker push registry.heroku.com/example123-dev:1.0.0/web