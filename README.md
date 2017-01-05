# Deploying a NodeJS App (in combination with Zeit, Docker, CircleCI and Heroku)

## How to test example App locally

```NodeJS
run npm start
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
> Ready! https://myapp-kkoizhpoud.now.sh (copied to clipboard) [2s]
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
docker build -t myapp-latest .
docker run myapp-latest
```

You should see something like this:

```
> npm info it worked if it ends with ok
> npm info using npm@3.10.10
> npm info using node@v7.3.0
> npm info lifecycle myapp@0.1.0~prestart: myapp@0.1.0
> npm info lifecycle myapp@0.1.0~start: myapp@0.1.0
> myapp@0.1.0 start /usr/src/app
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
> npm info lifecycle myapp@0.1.0~start: myapp@0.1.0
> npm info lifecycle myapp@0.1.0~prestart: myapp@0.1.0
> > myapp@0.1.0 start /usr/src/app
> > node ./server/server
> Example app listening on port 3000!
> Deployment complete!                                                               
```

## How to deploy example App to Heroku (with Docker)



### Helpful resources / References

#### Zeit

[https://zeit.co/now#whats-now](Zeit)

[https://zeit.co/now#get-started](Zeit)


#### Docker

[https://webapplog.com/node-docker]()

[https://docs.docker.com/](Docker)