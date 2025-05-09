pipeline {
  agent any
  environment {
    ECR_REGISTRY = '911264217807.dkr.ecr.us-west-2.amazonaws.com'
    ECR_REPO = 'rest-api'
    SONAR_URL = 'http://54.224.69.237:9000/'
  }
  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/deep-18/Build-A-High-Availability-System-Design-Assessment.git'
      }
    }

    // stage('Build and Test') {
    //   steps {
    //     sh 'cd app && mvn clean package'
    //   }
    // }

    stage('SonarQube Scan') {
      steps {
        withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_TOKEN')]) {
          sh '''
            cd app
            mvn sonar:sonar \
              -Dsonar.login=${SONAR_TOKEN} \
              -Dsonar.host.url=${SONAR_URL}
          '''
        }
      }
    }

    stage('Build and Push Docker Image') {
      environment {
        IMAGE_TAG = "backend-service-${BUILD_NUMBER}"
      }
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
          sh '''
            aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin ${ECR_REGISTRY}
            cd app
            docker build -t ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG} ./Application
            docker push ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}
          '''
        }
      }
    }

    stage('Update Manifest File') {
      steps {
        sh '''
          sed -i "s|image: .*|image: ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}|" k8s-manifest/deployment.yaml
          git config user.name "Deep"
          git config user.email "deepraval7408@gmail.com"
          git add k8s/deployment.yaml
          git commit -m "Update deployment image to ${IMAGE_TAG}"
          git push origin main
        '''
      }
    }

    // stage('Trigger Deployment Pipeline') {
    //   steps {
    //     build job: 'k8s-deploy-pipeline', parameters: [
    //       string(name: 'IMAGE_TAG', value: "${IMAGE_TAG}")
    //     ]
    //   }
    // }
  }
}
