APP_NAME=$2-$1
echo 'Heroku app name='
echo $APP_NAME

docker build -t $APP_NAME .
docker save -o $CIRCLE_ARTIFACTS/$2.tar $2
docker login --email=_ --username=_ --password=$HEROKU_API_KEY registry.heroku.com
docker tag $2 registry.heroku.com/$APP_NAME/web
docker push registry.heroku.com/$APP_NAME/web