# How to deploy example App to Heroku (with Docker)

First install Heroku CLI

https://devcenter.heroku.com/articles/heroku-cli#download-and-install

Then install the container-registry plugin by running:

```bash
heroku plugins:install heroku-container-registry
```

```bash
heroku container:login
heroku create
heroku container:push web --app yourappname
heroku open --app yourappname
```

You will see something like this

```bash
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
    - HEROKU_API_KEY: (see step above)
    - PORT: .. (the port on which the NodeJS server will listen. For example 80)
7. Edit the bash scripts under deploy folder so that "case-docker-api" is replaced by your app name.
8. Use one of the following scripts (comment/uncomment in *circle.yml*) and make sure you edit the parameters passed to the script
    - **deploy_using_dockerhubrepo_heroku.sh** (for deploying to Heroku and storing Docker image in AWS Container Registry)
        - 1st parameter: Heroku environment name ending (dev, staging, ..)
        - 2nd parameter: Heroku app name
        - 3rd parameter: dockerhub repository name
    - **deploy_using_awsdockerrepo_heroku.sh** (for deploying to Heroku and storing Docker image on Docker Hub)
        - 1st parameter: Heroku environment name ending (dev, staging, ..)
        - 2nd parameter: Heroku app name
        - 3rd parameter: AWS region
    
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

```bash
sh deploy/deploy_dockerhub_heroku.sh dev 
```
should be
```bash
sh deploy/deploy_dockerhub_heroku.sh development
```

**Optional: Edit circle.yml to add some kind of test to see whether the app starts correctly in the container**
```xslt
test:
    post:
        - docker build -t case-docker-api .
        - docker run -d -p $PORT:$PORT case-docker-api; sleep 10
        - curl --retry 10 --retry-delay 5 -v http://localhost:$PORT
```

**Optional:**
The docker image is saved as an artifact (but of course this is not necessary) so you can download the docker image after a deployment (you could use this..)
If you do not want this, remove this line**

```bash
docker save -o $CIRCLE_ARTIFACTS/example.tar case-docker-api
```

# How to deploy the example app to Heroku using CircleCI and Amazon EC2 Container Registry for docker image storage

1. Create CircleCI account & Heroku account
2. Clone this repo example into your own repository
3. Add the example project to CircleCI
4. Create a new Heroku app (if you do not have one already) or more when you have multiple environments (case-docker-api-dev, case-docker-api-staging, case-docker-api-prod in my case)
5. Copy your Heroku API key from your [Heroku account](https://dashboard.heroku.com/account)
6. In CircleCI Go to "Build Settings", then "Environment variables" and add these 2 variables
    - HEROKU_API_KEY: (see step above)
    - PORT: .. (the port on which the NodeJS server will listen. For example 80)
7. Login to AWS Console.
8. Create a repository on EC2 to hold your docker images (I named it case-docker-api)
9. Add environment variables to Circle CI: *AWS_ACCOUNT_ID*, *AWS_ACCESS_KEY_ID*, *AWS_SECRET_ACCESS_KEY*
   (You can find these when you login to AWS console)
10. Uncomment  `- sh deploy/deploy_aws_heroku.sh dev ` in circle.yml and comment `-sh deploy/deploy_dockerhub_heroku.sh dev` so the correct script is launched.
11. Rename the repository url to match your repository url. 'case-docker-api' in the deploy sh script to your repository name and possibly **'dkr.ecr.us-west-2.amazonaws.com'** should be changed.
12. Everything is the same as above except now the docker images are stored on Amazon instead of Docker Hub.

**Required step if your Heroku app name doesn't end with -dev or -staging"**

If your heroku app name does not end with -dev or -staging, the docker push won't work.
You have to edit the argument passed to the deploy script in circle.yml
Eg if your app name ends with 'development' instead of 'dev'

```bash
sh deploy/deploy_aws_heroku.sh dev 
```
should be
```
sh deploy/deploy_aws_heroku.sh development
```

# Heroku pipeline and Docker

Heroku curently (at time of writing: 12/01/2017) does not support promoting apps that are using Docker (for example staging => production)
> Promoting an application from staging to production in a Heroku pipeline will fail, yet appear to succeed. We’re working on support for pipelines.
> From [Heroku](https://devcenter.heroku.com/articles/container-registry-and-runtime)

As a workaround: if you want to deploy to production you can launch a bash script from your machine (a manual step that simulates promote).
- For deploying to docker hub , see an example here: `deploy/deploy_production_dockerhub_heroku.sh`
- For deploying to AWS container registry, see an example here `deploy/deploy_production_aws_heroku.sh`



# Helpful resources / References

## Heroku with Docker

[Heroku and docker](https://devcenter.heroku.com/articles/container-registry-and-runtime)
