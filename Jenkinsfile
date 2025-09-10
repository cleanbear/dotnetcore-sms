pipeline {
    agent any
    
  environment {
    ACR_NAME = 'donetdemo'           // change to your unique ACR name (lowercase)
    IMAGE_NAME = "${env.ACR_NAME}.azurecr.io/myapp"
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Azure Login') {
      steps {
        withCredentials([string(credentialsId: 'AZ_SP_APPID', variable: 'AZ_APP_ID'),
                         string(credentialsId: 'AZ_SP_PASSWORD', variable: 'AZ_PASSWORD'),
                         string(credentialsId: 'AZ_SP_TENANT', variable: 'AZ_TENANT')
                         string (credentialsId: 'AZ_SP_SUBSCRIPTION', variable: 'AZ_SUBSCRIPTION')]) {
          sh '''
            az login --service-principal --username "$AZ_APP_ID" --password "$AZ_PASSWORD" --tenant "$AZ_TENANT" --subcription "$AZ_SUBSCRIPTION"
          '''
        }
      }
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
          az acr login --name ${ACR_NAME}
          docker push ${IMAGE_NAME}:${BUILD_NUMBER}
        '''
      }
    }
  }
}
