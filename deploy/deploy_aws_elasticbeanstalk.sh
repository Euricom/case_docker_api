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
	aws configure set default.region $4
}

login_aws(){
    eval $(aws ecr get-login)
}

push_ecr_image(){

    # Build docker image
    docker build -t $2 .
    echo 'Building done'

    # Tag docker image
    docker tag $2:latest $AWS_ACCOUNT_ID.dkr.ecr.$4.amazonaws.com/$2:dev
    echo 'Tagging dev done'

    # Push docker image to Amazon EC2 Container Registry
    docker push $AWS_ACCOUNT_ID.dkr.ecr.$4.amazonaws.com/$2:dev
    echo 'Pushing dev done'

    docker logout
    echo 'Docker logout done'
}

cleanup_ecr_images(){
    # aws ecr batch-delete-image --repository-name case-docker-api --image-ids $(aws ecr list-images --repository-name case-docker-api -- filter tagStatus=UNTAGGED --query 'imageIds[*]'| tr -d " \t\n\r")
    # (previous oneliner not working anymore?)
    aws ecr list-images --repository-name $2 --query 'imageIds[?type(imageTag)!=`string`].[imageDigest]' --output text | while read line; do aws ecr batch-delete-image --repository-name $2 --image-ids imageDigest=$line; done
}

deploy_to_aws(){

    APP_NAME=$2
    EB_BUCKET=$3
    ZIP=$VERSION.zip
    APP_ENVIRONMENT=$2-dev

    # If development
    if [ $1 = "dev" ]; then

        # Zip up the Dockerrun.aws.json file. The zip name is the $VERSION.zip. The contents of the zip is the Dockerrun.aws.json
        zip -j deploy/$ZIP deploy/aws_dev/Dockerrun.aws.json

        GIT_HASH=$(git describe --always)
        VERSION_LABEL=development_$GIT_HASH
        
    # Else if staging, set label to version
    else

        # Zip up the Dockerrun.aws.json file. The zip name is the $VERSION.zip. The contents of the zip is the Dockerrun.aws.json
        zip -j deploy/$ZIP deploy/aws_staging/Dockerrun.aws.json
        VERSION_LABEL=$VERSION
    fi

    # Copy or replace zip in S3.
    aws s3 cp deploy/$ZIP s3://$EB_BUCKET/$ZIP
    
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