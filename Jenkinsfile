pipeline {
    agent any
    
  environment {
    ACR_NAME = 'donetdemo'       // change to your unique ACR name (lowercase)
    ACR_LOGIN_SERVER = 'donetdemo.azurecr.io'
    USERNAME = credentials('USERNAME') 
    PASSWORD = credentials('PASSWORD') 
    IMAGE_NAME = "${env.ACR_NAME}.azurecr.io/myapp" 
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
      }
    }
    stage('Push to ACR') {
            steps {
                sh """
                    echo "🔐 Logging in to ACR..."
                    docker login ${ACR_LOGIN_SERVER} -u ${USERNAME} -p ${PASSWORD}
                    
                    echo "📤 Pushing image..."
                    docker push ${IMAGE_NAME}:${BUILD_NUMBER}
                """
      }
    }
    stage('Deploy to AKS') {
    steps {
        withKubeConfig([credentialsId: 'aks-kubeconfig']) {
            sh """
                kubectl apply -f deployment.yaml
                kubectl rollout status deployment/myapp-deployment
            """
        }
      }
    }
  }
}
