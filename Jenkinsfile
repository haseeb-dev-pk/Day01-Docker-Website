pipeline {
  agent { label 'linux-docker-lab' }

  options {
    skipDefaultCheckout(true)
    disableConcurrentBuilds()
    timeout(time: 15, unit: 'MINUTES')
    buildDiscarder(logRotator(numToKeepStr: '10'))
  }

  parameters {
    string(
      name: 'EXPECTED_TEXT',
      defaultValue: 'Haseeb DevOps Lab',
      description: 'Text the page must contain'
    )
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Preflight') {
      steps {
        sh 'git --version && docker info && curl --version'
        sh 'bash -n scripts/ci-smoke.sh'
        sh 'mkdir -p artifacts && git rev-parse HEAD > artifacts/commit.txt'
      }
    }

    stage('Build image') {
      steps {
        sh 'docker build -t haseeb-day02-ci:$BUILD_NUMBER .'
      }
    }

    stage('Check website') {
      steps {
        sh 'bash scripts/ci-smoke.sh haseeb-day02-ci:$BUILD_NUMBER'
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'artifacts/*', allowEmptyArchive: true
      sh 'docker image rm haseeb-day02-ci:$BUILD_NUMBER || true'
    }
  }
}
