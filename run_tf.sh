#!/bin/bash


if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ] || [ -z "$AWS_REGION" ]; then
    echo "export the AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and AWS_REGION variables"
    exit 1
fi

command="$@"

[ -z "$command" ] && echo "Enter command" && exit 1

docker run -v $HOME/.aws:/root/.aws \
    -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
    -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
    -e AWS_REGION="$AWS_REGION" \
    -v $PWD:/terraform -w /terraform hashicorp/terraform:latest $command

