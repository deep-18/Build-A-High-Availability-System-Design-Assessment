pipeline {
  agent any
  environment {
    ECR_REGISTRY = '343434343434.dkr.ecr.us-west-2.amazonaws.com'
    ECR_REPO = 'rest-api'
    SONAR_URL = 'http://52.90.133.72:9000/' //This can also be configured directly using tool section of Jenkins
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
        ls -a
        docker build -t rest-api .
        docker tag rest-api:latest ${ECR_REGISTRY}/${ECR_REPO}:latest
        docker push ${ECR_REGISTRY}/${ECR_REPO}:latest
        '''
    }
}

stage('Update Kubernetes Deployment') {
      steps {
        sh '''
          cd k8s
          sed -i "s|image: .*|image: ${ECR_REGISTRY}/${ECR_REPO}:latest|g" deployment.yaml
          aws eks update-kubeconfig --region $AWS_REGION --name k8s-cluster
          kubectl apply -f deployment.yaml
        '''
      }
    }
  }
}


// Changes which can be added to this to make it more secure.

// 1. Utilized SonarQube for code analysis. We can also integrate it with Quality Gate to enforce minimum code quality thresholds before proceeding with builds.

// 2. We can integrate trivy or any other tool to scan the docker image for vulnerability before pushing them to registery.

// 3. Currently using sed to update the image in deployment manifests. While this is sufficient for simple use cases, 
// Kustomize or Helm would be a more robust and scalable solution for managing environment-specific configurations.

// 4. Ideally, Kubernetes manifests should reside in a separate Git repository and it should trigger another pipeline for more secured, modular and optimized format.
