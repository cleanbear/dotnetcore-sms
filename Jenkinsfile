pipeline {
    agent any
    
  environment {
    ACR_NAME = 'donetdemo'       // change to your unique ACR name (lowercase)
    ACR_LOGIN_SERVER = credentials('ACR_LOGIN_SERVER') 
    USERNAME = credentials('USERNAME') 
    PASSWORD = credentials('PASSWORD') 
    IMAGE_NAME = "${env.ACR_NAME}.azurecr.io/myapp" 
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Build Docker image') {
      steps {
        sh 'docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .'

      }
    }
    stage('Push to ACR') {
      steps {
        // az acr login will get docker credentials for the ACR (requires az logged in)
        sh '''
          docker login <ACR_LOGIN_SERVER> -u <USERNAME> -p <PASSWORD>
          docker push ${IMAGE_NAME}:${BUILD_NUMBER}
        '''
      }
    }
  }
}
