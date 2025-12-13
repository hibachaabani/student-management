pipeline {
    agent any

    environment {
        IMAGE_NAME = "hibachaabani/student-management"
        IMAGE_TAG  = "${env.BUILD_NUMBER}"        
        FULL_IMAGE = "${IMAGE_NAME}:${IMAGE_TAG}"
        GIT_CRED   = "github-path"
        DOCKER_CRED = "dockerhub-creds"
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/hibachaabani/student-management.git',
                    branch: 'main',
                    credentialsId: env.GIT_CRED
            }
        }

        stage('Maven Build') {
            steps { 
                dir('student-management') {
                    sh 'mvn clean package -DskipTests'
                } }
        }

        stage('SonarQube Analysis') {
            steps {
                dir('.') {
                    withSonarQubeEnv('SonarQube') {
                        sh 'mvn sonar:sonar'
                    }
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t ${FULL_IMAGE} .'
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: env.DOCKER_CRED, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push ${FULL_IMAGE}'
                }
            }
        }
    }

    post {
        success {
            echo "Image pushed: ${FULL_IMAGE}"
        }
        failure {
            echo "Pipeline failed"
        }
    }
}
