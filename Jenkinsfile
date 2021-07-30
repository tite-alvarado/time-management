#!groovy

pipeline {
  agent any
  options {
    // ansiColor('xterm')
    timestamps()
  }
  environment {
    ENV = "" // get from vault
   }
  parameters {
    string(name: 'BRANCH', description: 'code branch to build', defaultValue: 'master')
  }
    stages {
    stage('Initialaze pipeline parameters') {
      steps {
        checkout([$class: 'GitSCM',
          branches: [[name: "${BRANCH}"]],
          doGenerateSubmoduleConfigurations: false,
          gitTool: 'Default',
          extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'time-application']],
          submoduleCfg: [],
          userRemoteConfigs: [
            [
              // credentialsId: 'github_ssh',
              url: 'git@github.com:tite-alvarado/timeoff-management-application.git'
            ]
          ]
        ])
        checkout([$class: 'GitSCM',
          branches: [[name: "${BRANCH}"]],
          doGenerateSubmoduleConfigurations: false,
          gitTool: 'Default',
          extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: '.']],
          submoduleCfg: [],
          userRemoteConfigs: [
            [
              // credentialsId: 'github_ssh',
              url: 'git@github.com:tite-alvarado/time-management.git'
            ]
          ]
        ])
        script {
          if (params.BRANCH == '' || params.BRANCH == null) {
            currentBuild.result = 'ABORTED'
            error('No branch to build')
          } else {
            currentBuild.displayName = "${params.BRANCH}"
          }
          sh ' cd time-application ; npm install '
          sh ' docker build -t tm:${params.BRANCH} .'
        }
      }
    }
  }
}
