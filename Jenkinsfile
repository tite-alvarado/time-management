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
    stage('Checkout') {
      steps {
        checkout([$class: 'GitSCM',
          branches: [[name: "${BRANCH}"]],
          doGenerateSubmoduleConfigurations: false,
          gitTool: 'Default',
          extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'timeoff-management-application']],
          submoduleCfg: [],
          userRemoteConfigs: [
            [
              // credentialsId: 'github_ssh',
              url: 'git@github.com:tite-alvarado/timeoff-management-application.git'
            ]
          ]
        ])
        checkout([$class: 'GitSCM',
          branches: [[name: "master"]],
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
          sh ' mkdir -p target ; cd timeoff-management-application ; npm install ; # npm test '
          sh(script:" docker build -t tm:${params.BRANCH} . ", returnStdout: true)
        }
      }
    }
    stage('Archive Artifacts') {
      steps {
        script {
          sh(script: "tar cf target/timeoff-management-application_${params.BRANCH}_${env.BUILD_NUMBER}.tar timeoff-management-application", returnStdout: true)
          sh(script: "docker save tm:${params.BRANCH} | gzip > target/docker-timeoff-management-application_${params.BRANCH}_${env.BUILD_NUMBER}.tar.gz", returnStdout: true)
        }
        archiveArtifacts artifacts: 'target/*'
        cleanWs()
      }
    }
  }
}
