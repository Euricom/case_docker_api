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

    # Build docker image
    docker build -t example123 .
    echo 'Building done'

    # Tag docker image
    docker tag example123:latest $AWS_ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/example123:dev
    echo 'Tagging dev done'

    # Push docker image to Amazon EC2 Container Registry
    docker push $AWS_ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/example123:dev
    echo 'Pushing dev done'

    docker logout
    echo 'Docker logout done'
}

cleanup_ecr_images(){
    # aws ecr batch-delete-image --repository-name example123 --image-ids $(aws ecr list-images --repository-name example123 -- filter tagStatus=UNTAGGED --query 'imageIds[*]'| tr -d " \t\n\r")
    # (previous oneliner not working anymore?)
    aws ecr list-images --repository-name example123 --query 'imageIds[?type(imageTag)!=`string`].[imageDigest]' --output text | while read line; do aws ecr batch-delete-image --repository-name example123 --image-ids imageDigest=$line; done
}

deploy_to_aws(){

    APP_NAME=case-docker-api
    EB_BUCKET=elasticbeanstalk-us-west-2-708547824206
    ZIP=$VERSION.zip
    APP_ENVIRONMENT=caseDockerApi-dev

    # Zip up the Dockerrun file
    zip -j deploy/$ZIP deploy/aws_dev/Dockerrun.aws.json

    # Copy zip to aws S3
    aws s3 cp deploy/$ZIP s3://$EB_BUCKET/$ZIP

    # Delete current application version
    GIT_HASH=$(git describe --always)
    VERSION_LABEL=development_$GIT_HASH
    
    # Create a new application version with the zipped up Dockerrun file
    aws elasticbeanstalk create-application-version --application-name $APP_NAME \
        --version-label $VERSION_LABEL --source-bundle S3Bucket=$EB_BUCKET,S3Key=$ZIP

    # Update the environment to use the new application version
    aws elasticbeanstalk update-environment --environment-name $APP_ENVIRONMENT \
        --version-label $VERSION_LABEL
}

configure_aws_cli
login_aws
push_ecr_image
cleanup_ecr_images
deploy_to_aws