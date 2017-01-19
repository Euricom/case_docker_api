docker build -t case-docker-api .
docker save -o $CIRCLE_ARTIFACTS/case-docker-api.tar case-docker-api
docker login --email=_ --username=_ --password=$HEROKU_API_KEY registry.heroku.com
docker tag case-docker-api registry.heroku.com/case-docker-api-$1/web
docker push registry.heroku.com/case-docker-api-$1/web