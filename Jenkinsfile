pipeline {
  agent any
//   tools {
//     jdk 'jdk17'
//     nodejs 'node16'
//   }
  environment {
    ECR_REGISTRY = '911264217807.dkr.ecr.us-west-2.amazonaws.com'
    ECR_REPO = 'rest-api'
    SONAR_URL = 'http://54.162.166.58:9000/'
  }
  stages {
      stage('Checkout') {
          steps {
            git branch: 'main', url: 'https://github.com/deep-18/Build-A-High-Availability-System-Design-Assessment.git'
            sh "ls -l"
          }
      }
 
 stage('Static Code Analysis') {
      steps {
        withCredentials([string(credentialsId: 'sonar', variable: 'sonar')]) {
          sh '''cd Application/ && sonar-scanner \
            -Dsonar.projectKey=Node \
            -Dsonar.sources=. \
            -Dsonar.host.url=${SONAR_URL} \
            -Dsonar.login=${sonar}
        '''
        }
      }
    }
stage ("Docker Build and Push"){
    steps{
        sh'''
        ls -a
        cd Application
        aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin ${ECR_REGISTRY}
        docker build -t rest-api .
        docker tag rest-api:latest ${ECR_REGISTRY}/${ECR_REPO}:latest
        docker push ${ECR_REGISTRY}/${ECR_REPO}:latest
        '''
    }
}
  }
}
