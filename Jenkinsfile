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

        stage('Build & Test') {
            steps {
                // Windows 에이전트에서 Gradle 빌드
                bat 'gradlew.bat clean build'
            }
            post {
                always {
                    // JUnit 리포트 수집
                    junit '**/build/test-results/test/*.xml'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // 로컬 Docker에 이미지 빌드
                    docker.build("%IMAGE_NAME%:%BUILD_NUMBER%")
                }
            }
        }

        stage('Deploy to Local Docker') {
            steps {
                // 기존 컨테이너 중지·삭제 후 새로 실행
                bat """
                    docker stop myapp || echo Stopping skipped
                    docker rm myapp   || echo Removal skipped
                    docker run -d --name myapp -p 8080:8080 %IMAGE_NAME%:%BUILD_NUMBER%
                """
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
