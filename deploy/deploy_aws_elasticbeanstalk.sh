#!/bin/bash
# Ensure exit codes other than 0 fail the build
set -e

# CircleCI artifacts folder (sort of output folder)
# echo $CIRCLE_ARTIFACTS

# Get version from package.json
VERSION=$(node server/extractversion.js)
echo $VERSION

AWS_ACCOUNT_ID=708547824206
ENVIRONMENT=$1
AWS_APP=$2
EB_BUCKET=$3
REGION=$4
AWS_APP_ENVIRONMENT=$5
DOCKER_REPO=$6

configure_aws_cli(){
    echo $REGION
	aws --version
	aws configure set default.region $REGION
}

login_aws(){
    eval $(aws ecr get-login)
}

push_ecr_image(){

    # Build docker image
    docker build -t $AWS_APP .
    echo 'Building done'

     # If development, create docker image with tag :dev
    if [ $ENVIRONMENT = "dev" ]; then

        # Tag docker image
        docker tag $AWS_APP:latest $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$AWS_APP:dev
        echo 'Tagging dev done'

        # Push docker image to Amazon EC2 Container Registry
        docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$AWS_APP:dev
        echo 'Pushing dev done'

    else

        # Tag docker image
        docker tag $AWS_APP:latest $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$AWS_APP:latest
        echo 'Tagging latest done'

        # Push docker image to Amazon EC2 Container Registry
        docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$AWS_APP:latest
        echo 'Pushing latest done'

        # Tag docker image
        docker tag $AWS_APP:latest $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$AWS_APP:$VERSION
        echo 'Tagging $VERSION done'

        # Push docker image to Amazon EC2 Container Registry
        docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$AWS_APP:$VERSION
        echo 'Pushing $VERSION done'

    fi

    docker logout
    echo 'Docker logout done'
}

cleanup_ecr_images(){
    # aws ecr batch-delete-image --repository-name $AWS_APP --image-ids $(aws ecr list-images --repository-name $AWS_APP -- filter tagStatus=UNTAGGED --query 'imageIds[*]'| tr -d " \t\n\r")
    # (previous oneliner not working anymore?)
    aws ecr list-images --repository-name $AWS_APP --query 'imageIds[?type(imageTag)!=`string`].[imageDigest]' --output text | while read line; do aws ecr batch-delete-image --repository-name $AWS_APP --image-ids imageDigest=$line; done
}

deploy_to_aws(){


    # If development
    if [ $ENVIRONMENT = "dev" ]; then

        echo 'Dockerrun.aws.json = DEV'
        ZIP=development.zip

        # Create a zip that contains the Dockerrun.aws.json file.
        # The zip name is the development.zip
        # The contents of the zip is the Dockerrun.aws.json with docker image, tag :dev
        zip -j deploy/development.zip deploy/aws_dev/Dockerrun.aws.json

        # Copy or replace zip in S3.
        aws s3 cp deploy/$ZIP s3://$EB_BUCKET/$ZIP

        GIT_HASH=$(git describe --always)
        VERSION_LABEL=development_$GIT_HASH
        
    # Else if staging, set label to version
    else
   
        echo 'Dockerrun.aws.json = STAGING'
        ZIP=$VERSION.zip

        IMAGE_NAME=$DOCKER_REPO
        IMAGE_NAME+=:$VERSION

        # Edit the Dockerrun.aws.json so that the tag is the correct version tag
        cat deploy/aws_staging/Dockerrun.aws.json | jq --arg v "$IMAGE_NAME"  '.Image.Name=$v' > deploy/aws_staging/tmp.$$.json && mv deploy/aws_staging/tmp.$$.json deploy/aws_staging/Dockerrun.aws.json

        # Create a zip that contains the Dockerrun.aws.json file.
        zip -j deploy/$ZIP deploy/aws_staging/Dockerrun.aws.json

        # Copy or replace zip in S3.
        aws s3 cp deploy/$ZIP s3://$EB_BUCKET/$ZIP

        # Zip up the Dockerrun.aws.json file. The zip name is the $VERSION.zip. The contents of the zip is the Dockerrun.aws.json
        VERSION_LABEL=$VERSION
    fi
    
    # Create a new application version with the zipped up Dockerrun file
    aws elasticbeanstalk create-application-version --application-name $AWS_APP \
        --version-label $VERSION_LABEL --source-bundle S3Bucket=$EB_BUCKET,S3Key=$ZIP

    # Update the environment to use the new application version
    aws elasticbeanstalk update-environment --environment-name $AWS_APP_ENVIRONMENT \
        --version-label $VERSION_LABEL
}

configure_aws_cli
login_aws
push_ecr_image
cleanup_ecr_images
deploy_to_aws