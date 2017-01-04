# Deploying a NodeJS App (in combination with Zeit, Docker, CircleCI and Heroku)

## How to test example App locally

```NodeJS
run npm start
```

Then navigate to `http://localhost:3000/`

## How to deploy example App to Zeit

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

## Deploy Local Node Express App to Local Docker Machine container



### Helpful resources

[https://zeit.co/now#whats-now](Zeit)

[https://zeit.co/now#get-started](Zeit)