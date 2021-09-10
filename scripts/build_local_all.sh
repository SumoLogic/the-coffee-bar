#!/bin/bash

ROOT_DIR="$(pwd)"
MAIN_DOCKER_TAG="sumo/the-coffee-bar-app"

AWS_ACCOUNT_NUMBER=${1}
AWS_REGION=us-west-2
REGISTRY=${AWS_ACCOUNT_NUMBER}.dkr.ecr.${AWS_REGION}.amazonaws.com

PUSH=${2:-"false"}
AWS_REPOSITORY="tracing-demo-java/tracing-demo-java"

push_to_aws_repository () {
  local tag=${1}
  if [ ${PUSH} != "false" ]; then
    docker push ${REGISTRY}/${AWS_REPOSITORY}:${tag}
  fi
}

# Build ASP .NET Core application
DOTNET_APP_TAG=calculator-dotnet-1.1.0b4-1.0.0rc5

cd ${ROOT_DIR}/applications/dotnet-core-the-coffee-bar-app
docker build -t "${MAIN_DOCKER_TAG}:${DOTNET_APP_TAG}" .
docker tag "${MAIN_DOCKER_TAG}:${DOTNET_APP_TAG}" ${REGISTRY}/${AWS_REPOSITORY}:${DOTNET_APP_TAG}
push_to_aws_repository ${DOTNET_APP_TAG}

#Build Python applications
PYTHON_APP_TAG=python-apps-1.5.0-0.24b0


cd ${ROOT_DIR}/applications/python-the-coffee-bar-apps
docker build -t "${MAIN_DOCKER_TAG}:${PYTHON_APP_TAG}" .
docker tag "${MAIN_DOCKER_TAG}:${PYTHON_APP_TAG}" ${REGISTRY}/${AWS_REPOSITORY}:${PYTHON_APP_TAG}
push_to_aws_repository ${PYTHON_APP_TAG}

# Build Ruby applications
RUBY_APP_TAG=ruby-apps-1.0.0rc3-0.20.1-0.20.3

cd ${ROOT_DIR}/applications/ruby-the-coffee-bar-apps
docker build -t "${MAIN_DOCKER_TAG}:${RUBY_APP_TAG}" .
docker tag "${MAIN_DOCKER_TAG}:${RUBY_APP_TAG}" ${REGISTRY}/${AWS_REPOSITORY}:${RUBY_APP_TAG}
push_to_aws_repository ${RUBY_APP_TAG}

# Build javascript applications
JS_APP_TAG=frontend-js-0.18.2-1

cd ${ROOT_DIR}/applications/the-coffee-bar-frontend
docker build -t "${MAIN_DOCKER_TAG}:${JS_APP_TAG}" .
docker tag "${MAIN_DOCKER_TAG}:${JS_APP_TAG}" ${REGISTRY}/${AWS_REPOSITORY}:${JS_APP_TAG}
push_to_aws_repository ${JS_APP_TAG}

## Build clicker app
CLICKER_APP_TAG=clicker-linux
#
cd ${ROOT_DIR}/applications/js-the-coffee-bar-ui-clicker
docker build -f Dockerfile.linux -t "${MAIN_DOCKER_TAG}:${CLICKER_APP_TAG}" .
docker tag "${MAIN_DOCKER_TAG}:${CLICKER_APP_TAG}" ${REGISTRY}/${AWS_REPOSITORY}:${CLICKER_APP_TAG}
push_to_aws_repository ${CLICKER_APP_TAG}

if [[ "$(docker images -q ${MAIN_DOCKER_TAG}:/${DOTNET_APP_TAG} 2> /dev/null)" == "" &&
      "$(docker images -q ${MAIN_DOCKER_TAG}:/${PYTHON_APP_TAG} 2> /dev/null)" == "" &&
      "$(docker images -q ${MAIN_DOCKER_TAG}:/${RUBY_APP_TAG} 2> /dev/null)" == "" &&
      "$(docker images -q ${MAIN_DOCKER_TAG}:/${JS_APP_TAG} 2> /dev/null)" == "" &&
      "$(docker images -q ${MAIN_DOCKER_TAG}:/${CLICKER_APP_TAG} 2> /dev/null)" == "" ]]; then

  echo "****************************************************************************************"
  echo "All images are built. Please go to 'deployments/docker-compose' directory and run 'docker-compose up'"
  echo "****************************************************************************************"
fi
