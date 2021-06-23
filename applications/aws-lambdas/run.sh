#!/bin/bash

set -e
set -u

echo_usage () {
    echo "usage: Deploy The Coffee Bar App AWS Lambda Functions"
    echo " -r <aws region>"
    echo " -t <cloudformation template>"
    echo " -b <sam build>"
    echo " -d <sam deploy>"
    echo " -s <stack name>"
}

main () {
    echo "running..."
    saved_args="$@"
    template='template.yml'
    build=false
    deploy=false
    invoke=false
    stack=${STACK-"the-coffee-bar"-$(date +'%s')}
    region=${AWS_REGION-$(aws configure get region)}

    while getopts "hbdxnlr:t:s:" opt; do
        case "${opt}" in
            h) echo_usage
                exit 0
                ;;
            b) build=true
                ;;
            d) deploy=true
                ;;
            r) region="${OPTARG}"
                ;;
            t) template="${OPTARG}"
                ;;
            s) stack="${OPTARG}"
                ;;
            \?) echo "Invalid option: -${OPTARG}" >&2
                exit 1
                ;;
            :)  echo "Option -${OPTARG} requires an argument" >&2
                exit 1
                ;;
        esac
    done

    echo "Invoked with: ${saved_args}"

    if [[ $build == false && $deploy == false ]]; then
        build=true
        deploy=true
    fi

    if [[ $build == true ]]; then
        echo "sam building..."
        rm -rf .aws-sam
        sam build -u -t $template
    fi

    if [[ $deploy == true ]]; then
        echo "sam deploying..."
        sam deploy --stack-name $stack --region $region --capabilities CAPABILITY_NAMED_IAM --resolve-s3
    fi
}

main "$@"
