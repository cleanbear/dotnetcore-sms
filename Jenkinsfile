pipeline {
    agent any

  environment {
        DOTNET_HOME = "/Downloads/Software/Dotnet8"  // update this path if dotnet is installed elsewhere
        PATH = "${DOTNET_HOME}:${env.PATH}"
    }

    stages {
        stage('Checkout') {
            steps {
                // Pull from GitHub (Jenkins will use the repo configured in the job)
                checkout scm
            }
        }

        stage('Restore') {
            steps {
                sh 'dotnet restore'
            }
        }

        stage('Build') {
            steps {
                sh 'dotnet build --configuration Release --no-restore'
            }
        }

        stage('Test') {
            steps {
                sh 'dotnet test --configuration Release --no-build --verbosity normal'
            }
        }

        stage('Publish') {
            steps {
                sh 'dotnet publish -c Release -o ./publish'
            }
        }
    }

    post {
        success {
            archiveArtifacts artifacts: 'publish/**', fingerprint: true
        }
        failure {
            echo 'Build failed!'
        }
    }
}
