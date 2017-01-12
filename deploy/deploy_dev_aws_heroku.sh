#!/bin/bash
# Ensure exit codes other than 0 fail the build
set -e

# CircleCI artifacts folder (sort of output folder)
# echo $CIRCLE_ARTIFACTS

# Get version from package.json
VERSION=$(node server/extractversion.js)
echo $VERSION

configure_aws_cli(){
	aws --version
	aws configure set default.region us-west-2
}

login_aws(){
    eval $(aws ecr get-login)
}

push_ecr_image(){

    echo 'AWS ACCOUNT ID='
    echo $AWS_ACCOUNT_ID

    # Build docker image
    docker build -t example123 .
    echo 'Building done'

    # Tag docker image
    docker tag example123:latest $AWS_ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/example123:latest
    echo 'Tagging latest done'

    # Push docker image to Amazon EC2 Container Registry
    docker push $AWS_ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/example123:latest
    echo 'Pushing latest done'

    # Tag docker image
    docker tag example123 $AWS_ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/example123:$VERSION
    echo 'Tagging $VERSION done'

    # Push docker image to Amazon EC2 Container Registry
    docker push $AWS_ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/example123:$VERSION
    echo 'Pushing $VERSION done'

    docker logout
    echo 'Docker logout done'
}

cleanup_ecr_images(){
    # aws ecr batch-delete-image --repository-name example123 --image-ids $(aws ecr list-images --repository-name example123 -- filter tagStatus=UNTAGGED --query 'imageIds[*]'| tr -d " \t\n\r")
    # (previous oneliner not working anymore?)
    aws ecr list-images --repository-name example123 --query 'imageIds[?type(imageTag)!=`string`].[imageDigest]' --output text | while read line; do aws ecr batch-delete-image --repository-name example123 --image-ids imageDigest=$line; done
}

deploy_to_heroku(){
     
    # Login to Heroku repository
    docker login --email=_ --username=_ --password=$HEROKU_API_KEY registry.heroku.com
    echo "Successful login to Heroku"

    # Deploy to Heroku
    docker tag example123 registry.heroku.com/example123-dev/web
    docker push registry.heroku.com/example123-dev/web
}

configure_aws_cli
login_aws
push_ecr_image
cleanup_ecr_images
deploy_to_heroku