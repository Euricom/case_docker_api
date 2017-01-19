REMOTE=wimvandenrul
NAME=case-docker-api

# Login to Docker Hub
docker login

# Get latest docker image
docker pull $REMOTE/$NAME:latest

# Logout from Docker Hub
docker logout

# Login to Heroku repository
docker login --email=_ --username=_ registry.heroku.com
echo "Successful login to Heroku"

# Deploy to Heroku
REMOTE=registry.heroku.com
docker tag $REMOTE/$NAME registry.heroku.com/case-docker-api-prod/web
docker push registry.heroku.com/case-docker-api-prod/web