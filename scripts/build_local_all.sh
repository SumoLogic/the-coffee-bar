#!/bin/bash

ROOT_DIR="$(pwd)"
MAIN_DOCKER_TAG="sumo/the-coffee-bar-app"

# Build ASP .NET Core application
DOTNET_APP_TAG=dotnet-core-calculator-svc

cd ${ROOT_DIR}/applications/dotnet-core-the-coffee-bar-app
docker build -t "${MAIN_DOCKER_TAG}:${DOTNET_APP_TAG}" .

# Build Python applications
PYTHON_APP_TAG=python-apps

cd ${ROOT_DIR}/applications/python-the-coffee-bar-apps
docker build -t "${MAIN_DOCKER_TAG}:${PYTHON_APP_TAG}" .

# Build Ruby applications
RUBY_APP_TAG=ruby-apps

cd ${ROOT_DIR}/applications/ruby-the-coffee-bar-apps
docker build -t "${MAIN_DOCKER_TAG}:${RUBY_APP_TAG}" .

if [[ "$(docker images -q ${MAIN_DOCKER_TAG}:/${DOTNET_APP_TAG} 2> /dev/null)" == "" &&
      "$(docker images -q ${MAIN_DOCKER_TAG}:/${PYTHON_APP_TAG} 2> /dev/null)" == "" &&
      "$(docker images -q ${MAIN_DOCKER_TAG}:/${RUBY_APP_TAG} 2> /dev/null)" == "" ]]; then

  echo "****************************************************************************************"
  echo "All images are built. Please go to 'dockerization' directory and run 'docker-compose up'"
  echo "****************************************************************************************"
fi
