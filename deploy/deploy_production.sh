# If package.json script "deployproduction" is too complex for deploy , we use the following bash script

# TODO: Use the staging docker image at docker hub for deployment
# TODO add parameters for specifying which version to deploy (the docker image must exist of course!) or if parameter was not used , deploy latest version

# 1) TODO Load docker image from docker hub (docker pull ? .. get correct version/tag)
# 2) TODO Push the docker image to heroku (use Heroku toolset ?.) with app name example123-production