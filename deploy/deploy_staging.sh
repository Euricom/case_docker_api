#!/bin/bash
# Ensure exit codes other than 0 fail the build
set -e

# TEST
echo $CIRCLE_ARTIFACTS

# Get version from package.json
VERSION=$(node server/extractversion.js)
echo $VERSION;

# Create TAG name (attach version)
$TAG = "registry.heroku.com/example123-staging/"
$TAG += $VERSION
$TAG += "/web"
echo $TAG

# Build docker image
docker build -t $TAG .
# Save docker image to artifacts folder in Circle CI
docker save -o $CIRCLE_ARTIFACTS/example.tar $TAG
# Login to Heroku repository
docker login --email=_ --username=_ --password=$HEROKU_API_KEY registry.heroku.com
# Push the docker image (deploy to Heroku)
docker push $TAG

# TODO Login to Docker Hub
# TODO Save docker image (with version tag) in Docker hub (docker push) for use later (if we want to go to production)