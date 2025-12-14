pipeline {
    agent any

    environment {
        IMAGE_NAME  = "hibachaabani/student-management"
        IMAGE_TAG   = "${env.BUILD_NUMBER}"        
        FULL_IMAGE  = "${IMAGE_NAME}:${IMAGE_TAG}"
        GIT_CRED    = "github-path"
        DOCKER_CRED = "dockerhub-cred"
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
                }
            }
        }


        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                  kubectl apply -f mysql-deployment.yaml
                  kubectl apply -f spring-app-deployment.yaml
                  kubectl rollout restart deployment spring-app
                '''
            }
        }
    }

    post {
        success {
            echo "CI/CD completed successfully 🚀"
            echo "Image deployed: ${FULL_IMAGE}"
        }
        failure {
            echo "Pipeline failed ❌"
        }
    }
}
