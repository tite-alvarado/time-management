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
    booleanParam(name: 'DEPLOY', description: 'do docker deployment', defaultValue: true)
    string(name: 'PORT', description: 'Port to expose the application on', defaultValue: '3030')
  }
  stages {
    stage('Checkout') {
      steps {
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
        dir('timeoff-management-application') {
          checkout([$class: 'GitSCM',
            branches: [[name: "${BRANCH}"]],
            doGenerateSubmoduleConfigurations: false,
            gitTool: 'Default',
            submoduleCfg: [],
            userRemoteConfigs: [
              [
                url: 'git@github.com:tite-alvarado/timeoff-management-application.git'
              ]
            ]
          ])
        }
        script {
          if (params.BRANCH == '' || params.BRANCH == null) {
            currentBuild.result = 'ABORTED'
            error('No branch to build')
          } else {
            currentBuild.displayName = "${params.BRANCH}"
          }
          sh ' mkdir -p target '
          sh ' cd timeoff-management-application ; npm install ; npm start & sleep 5 && npm run-script db-update # && USE_CHROME=1 npm test '
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
      }
    }
    stage('Deployment') {
      steps {
        script {
          if (params.DEPLOY) {
            sh(script: "ansible-playbook -l nodeapp -i inventory --key ~/.ssh/dreamcompute.pem ansible/install_nodejsserver.yml -e app=~/jobs/time-management/builds/${env.BUILD_NUMBER}/archive/target/timeoff-management-application_${params.BRANCH}_${env.BUILD_NUMBER}.tar -e app_port=${params.PORT}", returnStdout: true)
            // sh(script: "ansible-playbook -l nodeapp -i inventory --key ~/.ssh/dreamcompute.pem ansible/install_docker.yml -e app=target/docker-timeoff-management-application_${params.BRANCH}_${env.BUILD_NUMBER}.tar.gz", returnStdout: true)
          }
        }
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}
