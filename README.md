# Deploying a NodeJS App (in combination with Zeit, Docker, CircleCI and Heroku)

## Install example app locally

```NodeJS
npm install
```

## How to test example App locally

```NodeJS
npm run start
```

Then navigate to `http://localhost:3000/`

## How to deploy example App to Zeit (without docker)

**Note: Delete or rename the Dockerfile before continuing 
(if you do not it will upload the app as a docker container )**

* Download Zeit command line tool from  [https://zeit.co/download#command-line](Zeit)
* Or you can also install it with npm as follows: `npm install -g now`

Run `now`

You should see something like this

```
> Deploying ~\Documents\git\case_docker_api\server
> Using Node.js 7.0.0 (default)
> Ready! https://example123-kkoizhpoud.now.sh (copied to clipboard) [2s]
> Upload [====================] 100% 0.0s
> Sync complete (1.77kB) [1s]
> Initializing…
> Building
> ▲ npm install
> Installing package body-parser@~1.15.2
> Installing package cookie-parser@~1.4.3
> Installing package debug@~2.2.0
> Installing package jade@~1.11.0
> Installing package express@~4.14.0
> Installing package morgan@~1.7.0
> Installing package serve-favicon@~2.3.0
> ▲ npm start
> Deployment complete!
```
The app is now deployed to Zeit. Now paste the url in the browser.

## How to deploy example App to a Local Docker Machine

```Docker
docker build -t example123 .
docker run example123 -p 3000:3000
```

You should see something like this:

```
> npm info it worked if it ends with ok
> npm info using npm@3.10.10
> npm info using node@v7.3.0
> npm info lifecycle example123@0.1.0~prestart: example123@0.1.0
> npm info lifecycle example123@0.1.0~start: example123@0.1.0
> example123@0.1.0 start /usr/src/app
> node ./server/server
> Example app listening on port 3000!
```
## How to deploy example App to Zeit (with Docker)

Easy ;) run `now`

Then you get the option:

```
> [1] package.json         --npm
> [2] Dockerfile        --docker
```

Choose 2 , then you will get some output like

```
> No `name` LABEL in `Dockerfile`, using case_docker_api
> Ready! https://casedockerapi-csmemzzrui.now.sh (copied to clipboard) [58s]
> Upload [====================] 100% 0.0s
> Sync complete (4kB) [2s]
> Initializing…
> Building
> ▲ docker build
> Removing intermediate container 78fb4c4f6a76
> Step 7 : EXPOSE 3000
>  ---> Running in 48e2961c596d
>  ---> 27f016a95062
> Removing intermediate container 48e2961c596d
> Step 8 : CMD npm start
>  ---> Running in 5f46033bf55a
>  ---> f81aa12fc89a
> Removing intermediate container 5f46033bf55a
> Successfully built f81aa12fc89a
> ▲ Storing image
> ▲ Deploying image
> ▲ Container started
> npm info it worked if it ends with ok
> npm info using npm@3.10.10
> npm info using node@v7.3.0
> npm info lifecycle example123@0.1.0~start: example123@0.1.0
> npm info lifecycle example123@0.1.0~prestart: example123@0.1.0
> > example123@0.1.0 start /usr/src/app
> > node ./server/server
> Example app listening on port 3000!
> Deployment complete!                                                               
```

## How to deploy example App to Heroku (with Docker)

```Heroku
heroku plugins:install heroku-container-registry
```

```Heroku
heroku container:login
heroku create
heroku container:push web --app yourappname
heroku open --app yourappname
```

You will see something like this

```
> Sending build context to Docker daemon 20.36 MB
> Step 1 : FROM node:alpine
>  ---> d0a6661914f4
> Step 2 : RUN mkdir -p /usr/src/app
>  ---> Using cache
>  ---> 82e9943a8164
> Step 3 : WORKDIR /usr/src/app
>  ---> Using cache
>  ---> c4e5ac432ca8
> Step 4 : COPY . /usr/src/app
> ---> 7285fa61484a
> Removing intermediate container 493333da1839
> Step 5 : COPY package.json /usr/src/app/
>  ---> d12002b41e4c
> Removing intermediate container 8b596311b42a
> Step 6 : RUN npm install
>  ---> Running in 7d9119f19f3c
> npm info it worked if it ends with ok
> npm info using npm@3.10.10
> npm info using node@v7.3.0
> npm info lifecycle example123@0.1.0~preinstall: example123@0.1.0
> npm info linkStuff example123@0.1.0
> npm info lifecycle example123@0.1.0~install: example123@0.1.0
> npm info lifecycle example123@0.1.0~postinstall: example123@0.1.0
> npm info lifecycle example123@0.1.0~prepublish: example123@0.1.0
> npm info ok
>  ---> e2f3affa48f7
> Removing intermediate container 7d9119f19f3c
> Step 7 : EXPOSE 3000
>  ---> Running in 9a8b57fe6908
>  ---> b7cb9ee571de
> Removing intermediate container 9a8b57fe6908
> Step 8 : CMD npm start
>  ---> Running in 3742e9cd9271
>  ---> 6aa1efeb0a45
> Removing intermediate container 3742e9cd9271
> Successfully built 6aa1efeb0a45
> SECURITY WARNING: You are building a Docker image from Windows against a non-Windows Docker host. All files and directories added to build context will have '-rwxr-xr-x' permissions. It is recommended to double check and reset permissions for sensitive files and directories.
> The push refers to a repository [registry.heroku.com/example123-dev/web]
> af423bb0e78f: Pushed
> 5d40bb2d896f: Pushed
> 1c809f2c94c1: Pushed
> 5b8409dad2ee: Layer already exists
> 301bf20360e2: Layer already exists
> 7cbcbac42c44: Layer already exists
> latest: digest: sha256:676ec9dfd05e3d018d4da4a1a301145bb13184c40f7845506d7f0b73a2c8582c size: 1572
```

## How to deploy example App to Heroku (using CircleCI and Docker)

1. Create CircleCI account & Heroku account
2. Clone this repo example into your own repository
3. Add the example project to CircleCI
4. Create a new Heroku app (if you do not have one already)
5. Copy your Heroku API key from your [Heroku account](https://dashboard.heroku.com/account)
6. In CircleCI Go to "Build Settings", then "Environment variables" and add these 2 variables
    1. HEROKU_API_KEY: (see step above)
    2. PORT: .. (the port on which the NodeJS server will listen. For example 3000)
7. Edit the circle.yml file in the root of the example so that "yourappname" is replaced by your app name.

**Optional: Edit circle.yml to add some kind of test to see whether the app starts correctly in the container**
```
test:
    post:
        - docker build -t example123 .
        - docker run -d -p $PORT:$PORT example123; sleep 10
        - curl --retry 10 --retry-delay 5 -v http://localhost:$PORT
```

**Optional:
The docker image is saved as an artifact (but of course this is not necessary) so you can download the docker image after a deployment (you could use this..)
If you do not want this, remove this line**

```
docker save -o $CIRCLE_ARTIFACTS/example.tar example123
```

## How to test this example app in Docker using different environment settings

You can use docker compose to accomplish this.
In the project there  are 2 docker compose files. One for dev and the other one for a production environment.

First create a docker image.

```
docker-compose build

```

Then start the app 

For development
```
docker-compose -f docker-compose.yml up
```
or production
```
docker-compose -f docker-compose.production.yml up
```

As an example you will see there is a different environment setting for a database connection string in this project.
This can be useful if you want to test the docker image on your local docker machine using a development database or rather connect to production database (or maybe another database..)

### Helpful resources / References

#### Zeit

[Zeit official website](https://zeit.co/now#whats-now)

[Get started with Zeit](https://zeit.co/now#get-started)


#### Docker

[Docker documentation](https://docs.docker.com/)

[Node with Docker](https://webapplog.com/node-docker)

[Docker Ignore file](https://docs.docker.com/engine/reference/builder/#dockerignore-file)

#### Heroku with Docker

[Heroku and docker](https://devcenter.heroku.com/articles/container-registry-and-runtime)

#### CircleCI with Docker

[CircleCI and docker](https://circleci.com/docs/docker/)
 