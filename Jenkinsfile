#!/usr/bin/groovy
@Library('jenkins-common')

def version
def sumo_repository = "sumologic/the-coffee-bar" 
def arun_repository = "g0d6f4n6/the-coffee-bar-arun"
// def sumo_ecr_registry = "https://366152261300.dkr.ecr.ap-south-1.amazonaws.com"
// def arun_ecr_registry = "https://366152261300.dkr.ecr.ap-south-1.amazonaws.com"
def sumo_ecr_registry = "https://681285326029.dkr.ecr.us-west-2.amazonaws.com"
def arun_ecr_registry = "https://681285326029.dkr.ecr.us-west-2.amazonaws.com"


pipeline {
  
  agent { label 'general' }

  options {
    timestamps()
    ansiColor('xterm')
    timeout(time: 3, unit: 'HOURS')
  }

  stages {

    stage("Build & Push - Sumo repo") {
      steps {
        script {
          docker.withRegistry(sumo_ecr_registry) {

            withAwsCredentialsFor("iahuja") {

              ensureECRRepository(sumo_repository)
              
              String gitCommitTimestamp = sh(label: 'Retrieve git commit timestamp', script: "git show -s --format=%ct ${env.GIT_COMMIT}", returnStdout: true).trim()
              version = "v-${gitCommitTimestamp}-${env.BUILD_ID}-${env.GIT_COMMIT?.substring(0, 12)}"

              println "[INFO] Building calculator-dotnet version: ${version}"
              def dotnetImage = docker.build("${sumo_repository}:calculator-dotnet-${version}", "-f applications/dotnet-core-the-coffee-bar-app/Dockerfile applications/dotnet-core-the-coffee-bar-app")

              println "[INFO] Building rubyApps version: ${version}"
              def rubyImage = docker.build("${sumo_repository}:rubyApps-${version}", "-f applications/ruby-the-coffee-bar-apps/Dockerfile applications/ruby-the-coffee-bar-apps")

              println "[INFO] Building clicker version: ${version}"
              def clickerImage = docker.build("${sumo_repository}:clicker-${version}", "-f applications/js-the-coffee-bar-ui-clicker/Dockerfile applications/js-the-coffee-bar-ui-clicker")

              println "[INFO] Pushing calculator-dotnet image with version: ${version}"
              dotnetImage.push()
              
              println "[INFO] Pushing rubyApps image with version: ${version}"
              rubyImage.push()
              
              println "[INFO] Pushing clicker image with version: ${version}"
              clickerImage.push()
            }
          }
        }
      }
    }

    stage("Build & Push - Arun repo") {
      steps {
        script {
          docker.withRegistry(arun_ecr_registry) {

            withAwsCredentialsFor("iahuja") {

              ensureECRRepository(arun_repository)

              String gitCommitTimestamp = sh(label: 'Retrieve git commit timestamp', script: "git show -s --format=%ct ${env.GIT_COMMIT}", returnStdout: true).trim()
              version = "v-${gitCommitTimestamp}-${env.BUILD_ID}-${env.GIT_COMMIT?.substring(0, 12)}"

              println "[INFO] Building frontend version: ${version}"
              def frontendImage = docker.build("${arun_repository}:frontend-${version}", "-f applications/the-coffee-bar-frontend/Dockerfile applications/the-coffee-bar-frontend")

              println "[INFO] Building python-apps version: ${version}"
              def pythonImage = docker.build("${arun_repository}:python-apps-${version}", "-f applications/python-the-coffee-bar-apps/Dockerfile applications/python-the-coffee-bar-apps")

              println "[INFO] Pushing frontend image with version: ${version}"
              frontendImage.push()

              println "[INFO] Pushing python-apps image with version: ${version}"
              pythonImage.push()
            }
          }          
        }
      }
    }
  }
}