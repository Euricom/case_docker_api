#!/bin/bash
# Ensure exit codes other than 0 fail the build
set -e

# TEST
echo $CIRCLE_ARTIFACTS

# Get version from package.json
VERSION=$(node server/extractversion.js)
echo $VERSION;

# Create TAG name (attach version)
APP = "registry.heroku.com/example123-staging/"
TAG = $VERSION
echo $APP

# Build docker image
docker build -t $APP:$TAG .
# Save docker image to artifacts folder in Circle CI
docker save -o $CIRCLE_ARTIFACTS/example.tar $APP:$TAG
# Login to Heroku repository
docker login --email=_ --username=_ --password=$HEROKU_API_KEY registry.heroku.com
# Push the docker image (deploy to Heroku)
docker push $APP:$TAG
