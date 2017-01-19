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
> Ready! https://case-docker-api-kkoizhpoud.now.sh (copied to clipboard) [2s]
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
> Step 7 : EXPOSE 80
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
> npm info lifecycle case-docker-api@0.1.0~start: case-docker-api@0.1.0
> npm info lifecycle case-docker-api@0.1.0~prestart: case-docker-api@0.1.0
> > case-docker-api@0.1.0 start /usr/src/app
> > node ./server/server
> Example app listening on port 80!
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
> npm info lifecycle case-docker-api@0.1.0~preinstall: case-docker-api@0.1.0
> npm info linkStuff case-docker-api@0.1.0
> npm info lifecycle case-docker-api@0.1.0~install: case-docker-api@0.1.0
> npm info lifecycle case-docker-api@0.1.0~postinstall: case-docker-api@0.1.0
> npm info lifecycle case-docker-api@0.1.0~prepublish: case-docker-api@0.1.0
> npm info ok
>  ---> e2f3affa48f7
> Removing intermediate container 7d9119f19f3c
> Step 7 : EXPOSE 80
>  ---> Running in 9a8b57fe6908
>  ---> b7cb9ee571de
> Removing intermediate container 9a8b57fe6908
> Step 8 : CMD npm start
>  ---> Running in 3742e9cd9271
>  ---> 6aa1efeb0a45
> Removing intermediate container 3742e9cd9271
> Successfully built 6aa1efeb0a45
> SECURITY WARNING: You are building a Docker image from Windows against a non-Windows Docker host. All files and directories added to build context will have '-rwxr-xr-x' permissions. It is recommended to double check and reset permissions for sensitive files and directories.
> The push refers to a repository [registry.heroku.com/case-docker-api-dev/web]
> af423bb0e78f: Pushed
> 5d40bb2d896f: Pushed
> 1c809f2c94c1: Pushed
> 5b8409dad2ee: Layer already exists
> 301bf20360e2: Layer already exists
> 7cbcbac42c44: Layer already exists
> latest: digest: sha256:676ec9dfd05e3d018d4da4a1a301145bb13184c40f7845506d7f0b73a2c8582c size: 1572
```

## How to deploy example App to Heroku (without CI and store image to Docker hub)

Pass correct values to script `deploy_using_dockerhubrepo_heroku`. 
For example `sh -x deploy/deploy_using_dockerrepo_heroku.sh dev case-docker-api euri`
In this example, the docker image is stored at https://hub.docker.com/r/euri/case-docker-api/

First parameter is the Heroku environment name.
Second parameter is the appname / Docker app name 
Third parameter is the Docker hub repository name

During execution of script you will be asked your Docker Hub login and your Heroku API key.

## How to deploy example App to Heroku using CircleCI and Docker

1. Create CircleCI account & Heroku account
2. Clone this repo example into your own repository
3. Add the example project to CircleCI
4. Create a new Heroku app (if you do not have one already) or more when you have multiple environments (case-docker-api-dev, case-docker-api-staging, case-docker-api-prod in my case)
5. Copy your Heroku API key from your [Heroku account](https://dashboard.heroku.com/account)
6. In CircleCI Go to "Build Settings", then "Environment variables" and add these 2 variables
    1. HEROKU_API_KEY: (see step above)
    2. PORT: .. (the port on which the NodeJS server will listen. For example 80)
7. Edit the bash scripts under deploy folder so that "case-docker-api" is replaced by your app name.

**Required steps (if you want to use Docker Hub)**

1. Create a Docker Hub account
2. Create a repository (I chose case-docker-api)
3. Add environment variables to Circle CI: *DOCKER_EMAIL*, *DOCKER_LOGIN*, *DOCKER_PASSWORD*

**Required steps (if you want to use Amazon EC2 Container Registry)**

1. Log in to your AWS account.
2. Go to EC2 Container Registry.
3. Create a repository
4. Find your *AWS Account ID*, *AWS Access Key* and *AWS Secret Key*
5. Add environment variables to Circle CI: *AWS_ACCOUNT_ID*, *AWS_ACCESS_KEY_ID*, *AWS_SECRET_ACCESS_KEY*
   (You can find these when you login to AWS console)

**Required step if your Heroku app name doesn't end with -dev or -staging"**

If your heroku app name does not end with -dev or -staging, the docker push won't work.
You have to edit the argument passed to the deploy script in circle.yml
Eg if your app name ends with 'development' instead of 'dev'

```
sh deploy/deploy_dockerhub_heroku.sh dev 
```
should be
```
sh deploy/deploy_dockerhub_heroku.sh development
```

**Optional: Edit circle.yml to add some kind of test to see whether the app starts correctly in the container**
```
test:
    post:
        - docker build -t case-docker-api .
        - docker run -d -p $PORT:$PORT case-docker-api; sleep 10
        - curl --retry 10 --retry-delay 5 -v http://localhost:$PORT
```

**Optional:**
The docker image is saved as an artifact (but of course this is not necessary) so you can download the docker image after a deployment (you could use this..)
If you do not want this, remove this line**

```
docker save -o $CIRCLE_ARTIFACTS/example.tar case-docker-api
```

## How to deploy the example app to Heroku using CircleCI and Amazon EC2 Container Registry for docker image storage

1. Create CircleCI account & Heroku account
2. Clone this repo example into your own repository
3. Add the example project to CircleCI
4. Create a new Heroku app (if you do not have one already) or more when you have multiple environments (case-docker-api-dev, case-docker-api-staging, case-docker-api-prod in my case)
5. Copy your Heroku API key from your [Heroku account](https://dashboard.heroku.com/account)
6. In CircleCI Go to "Build Settings", then "Environment variables" and add these 2 variables
    1. HEROKU_API_KEY: (see step above)
    2. PORT: .. (the port on which the NodeJS server will listen. For example 80)
7. Login to AWS Console.
8. Create a repository on EC2 to hold your docker images (I named it case-docker-api)
9. Add environment variables to Circle CI: *AWS_ACCOUNT_ID*, *AWS_ACCESS_KEY_ID*, *AWS_SECRET_ACCESS_KEY*
   (You can find these when you login to AWS console)
10. Uncomment  `- sh deploy/deploy_aws_heroku.sh dev ` in circle.yml and comment `-sh deploy/deploy_dockerhub_heroku.sh dev` so the correct script is launched.
11. Rename the repository url to match your repository url. 'case-docker-api' in the deploy sh script to your repository name and possibly 'dkr.ecr.us-west-2.amazonaws.com' should be changed.
12. Everything is the same as above except now the docker images are stored on Amazon instead of Docker Hub.

**Required step if your Heroku app name doesn't end with -dev or -staging"**

If your heroku app name does not end with -dev or -staging, the docker push won't work.
You have to edit the argument passed to the deploy script in circle.yml
Eg if your app name ends with 'development' instead of 'dev'

```
sh deploy/deploy_aws_heroku.sh dev 
```
should be
```
sh deploy/deploy_aws_heroku.sh development
```

## How to deploy the example app to AWS

1. You need to set up some basics in Amazon EC2: Create a Amazon EC2 Instance. I chose amzn-ami-2016.09.d-amazon-ecs-optimized (ami-5b6dde3b) because we need a working docker environment in the image.
   More info here [Amazon ECS-optimized AMI](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html)

   **Useful**
   You may want to add a key pair to your instance so you can SSH into it later if you experience any problems.

   **Important**
   I had to add the role AmazonEC2ContainerServiceforEC2Role to my instance otherwise the cluster I created (see below) could not find any instance.
   See this [Stackoverflow topic](http://stackoverflow.com/questions/36523282/aws-ecs-error-when-running-task-no-container-instances-were-found-in-your-clust)
   
2. Create a cluster (a cluster can contain one or more EC2 instances)

3. Create a task definition (this specifies which docker image you want to run).  You can use most default settings, except:
        
        1) Set correct container name, repository name and docker image tag
        2) You need to add a port mapping for running and exposing the ports used by the app. Add port Host 80 and Container port 80, protocol TCP.
        3) Add environment variables (if you have an app that needs this)

4. Make sure that your repository contains the docker image/tag.

5. Create a Service (set number of tasks to one) and add the previous task definition

5. Make sure that inbound http 80 is set for your instance (configure in security groups)

6. AWS will now try to start the task. Make sure the status is 'RUNNING' and there are no errors in events tab in service.
   Also check there are no errors in task under container details. 

7. You can find your app url in the current running task under container. (Under column external link)

8. Click the link. Hopefully your app is now displayed.


## Heroku pipeline and Docker

Heroku curently (at time of writing: 12/01/2017) does not support promoting apps that are using Docker (for example staging => production)
> Promoting an application from staging to production in a Heroku pipeline will fail, yet appear to succeed. We’re working on support for pipelines.
> From [Heroku](https://devcenter.heroku.com/articles/container-registry-and-runtime)

As a workaround: if you want to deploy to production you can launch a bash script from your machine (a manual step that simulates promote).
- For deploying to docker hub , see an example here: `deploy/deploy_production_dockerhub_heroku.sh`
- For deploying to AWS container registry, see an example here `deploy/deploy_production_aws_heroku.sh`

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


## Helpful resources / References

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

#### CircleCI with AWS

[CircleCI and AWS](http://mohtasebi.com/docker/aws/2016/03/08/ci-using-aws-ecs-docker.html)
 
#### Amazon EC2 Container Service

[Amazon Developer guide EC2 Container Service](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html)

#### Amazon EC2 Container Service Deploy Docker Containers

[Deploy Docker container: tutorial](https://aws.amazon.com/getting-started/tutorials/deploy-docker-containers/)