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
        stage('Stop IIS') {
            steps {
                sshPublisher(publishers: [
                    sshPublisherDesc(
                        configName: 'windows-vm',   // Your SSH config name in Jenkins
                        transfers: [
                            sshTransfer(
                                execCommand: 'iisreset /stop'
                            )
                        ],
                        usePromotionTimestamp: false,
                        verbose: true
                    )
                ])
            }
        }
        stage('Deploy via SSH') {
            steps {
                sshPublisher(publishers: [sshPublisherDesc(configName: 'windows-vm', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '/websites/myfirstapp/', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '**/*')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
            }
        }

        stage('Start IIS') {
            steps {
                sshPublisher(publishers: [
                    sshPublisherDesc(
                        configName: 'windows-vm',
                        transfers: [
                            sshTransfer(
                                execCommand: 'iisreset /start'
                            )
                        ],
                        usePromotionTimestamp: false,
                        verbose: true
                    )
                ])
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
