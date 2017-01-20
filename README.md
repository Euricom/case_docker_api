# Deploying a NodeJS App (in combination with Zeit, Docker, CircleCI and Heroku/Amazon AWS)

## Install example app locally

```NodeJS
npm install
```

## How to test example App locally

```NodeJS
npm run start
```

Then navigate to `http://localhost:80/`

## How to deploy example App to a Local Docker Machine

```Docker
docker build -t case-docker-api .
docker run case-docker-api -p 80:80
```
You should see something like this:

```
> npm info it worked if it ends with ok
> npm info using npm@3.10.10
> npm info using node@v7.3.0
> npm info lifecycle case-docker-api@0.1.0~prestart: case-docker-api@0.1.0
> npm info lifecycle case-docker-api@0.1.0~start: case-docker-api@0.1.0
> case-docker-api@0.1.0 start /usr/src/app
> node ./server/server
> Example app listening on port 80!
```

# How to test this example app in Docker using different environment settings

You can use docker compose to accomplish this.
In the project there  are 2 docker compose files. One for dev and the other one for a production environment.

First create a docker image.

```bash
docker-compose build

```

Then start the app 

For development
```bash
docker-compose -f docker-compose.yml up
```
or production
```bash
docker-compose -f docker-compose.production.yml up
```

As an example you will see there is a different environment setting for a database connection string in this project.
This can be useful if you want to test the docker image on your local docker machine using a development database or rather connect to production database (or maybe another database..)

## Deploying to Zeit

See [Readme Case Docker API Zeit](README_ZEIT.md)

## Deploying to Heroku

See [Readme Case Docker API Heroku](README_Heroku.md)

## Deploying to AWS Elastic Beanstalk

See [Readme Case Docker API AWS Elastic Beanstalk](https://github.com/Euricom/case_docker_api/blob/master/README_AMAZON_AWS.md)

# Helpful resources / References

## Docker

[Docker documentation](https://docs.docker.com/)

[Node with Docker](https://webapplog.com/node-docker)

[Docker Ignore file](https://docs.docker.com/engine/reference/builder/#dockerignore-file)

## CircleCI with Docker

[CircleCI and docker](https://circleci.com/docs/docker/)