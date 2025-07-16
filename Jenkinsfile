// 프로젝트 루트/Jenkinsfile
pipeline {
    agent any

    environment {
        IMAGE_NAME = 'com.example/myapp'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Prepare') {
                    steps {
                        // gradlew 에 실행 권한 부여
                        sh 'chmod +x gradlew'
                    }

        stage('Build & Test') {
            steps {
                // gradlew는 리눅스용 쉘 스크립트 gradlew가 같이 체크아웃된다는 가정
                sh './gradlew clean build'
            }
            post {
                always {
                    junit '**/build/test-results/test/*.xml'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${BUILD_NUMBER}")
                }
            }
        }

        stage('Deploy to Local Docker') {
            steps {
                sh '''
                    docker stop myapp || echo "Stopping skipped"
                    docker rm myapp   || echo "Removal skipped"
                    docker run -d --name myapp -p 8080:8080 ${IMAGE_NAME}:${BUILD_NUMBER}
                '''
            }
        }
    }

    post {
        success {
            echo "✅ 배포 성공: ${IMAGE_NAME}:${BUILD_NUMBER}"
        }
        failure {
            echo "❌ 배포 실패!"
        }
    }
}