# The Coffee Bar UI Clicker 
Simple JS application to generate the traffic on The Coffee Bar UI App

## Content
* `src` directory contains sources of the application
* `Dockerfile`'s file is used for docker image build
* `package.json`'s file with all dependencies needed to install the application

## Prerequisities
* Installed [docker-compose] (optional)

## How to build?

* To build locally running application, go to the root directory of the application and execute the command:
    ```bash
    npm install
    ```
* To build docker image run:
    ```bash
    TAG=clicker

    # Build Image
    docker build -t sumo/the-coffee-bar-app:${TAG} .
    ```
    
## Usage
### Application usage
The Coffee Bar UI Clicker can be configured by environment variables:
* `COFFEE_BAR_UI_URL` (default=http://the-coffee-bar-frontend:3000) - an `url` to The Coffee Bar Frontend
* `DELAY` (default=5) - an interval between new browser launch

Execution:
`npm src/clicker.js`

# Contact
In case of any issues please contact Mateusz 'mat' Rumian @ mrumian@sumologic.com


[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does 
its job. There is no need to format nicely because it shouldn't be seen. 
Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [docker-compose]: <https://docs.docker.com/compose/install/>
