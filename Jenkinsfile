pipeline {
    agent any

    tools {
        // Make sure you installed the .NET 8 SDK in Jenkins and added it as a tool
        // Otherwise, you can just call 'dotnet' directly if it's on PATH
        //dotnet 'dotnet8'
    }

    environment {
        DOTNET_CLI_TELEMETRY_OPTOUT = "1"
        DOTNET_SKIP_FIRST_TIME_EXPERIENCE = "true"
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
                //sh 'dotnet test --configuration Release --no-build --verbosity normal'
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
