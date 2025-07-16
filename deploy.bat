:: 프로젝트 루트/deploy.bat
@echo off
chcp 65001 >nul
REM Usage: deploy.bat <BUILD_NUMBER>
if "%~1"=="" (
  echo Usage: deploy.bat ^<BUILD_NUMBER^>
  exit /b 1
)

set BUILD_NO=%~1
set IMAGE_NAME=myapp

echo ===== 빌드된 JAR을 기반으로 Docker 이미지 태깅 및 빌드 =====
docker build -t %IMAGE_NAME%:%BUILD_NO% .

echo ===== 기존 컨테이너 중지 및 삭제 =====
docker ps -q -f name=%IMAGE_NAME% | findstr . >nul && docker stop %IMAGE_NAME%
docker ps -aq -f name=%IMAGE_NAME% | findstr . >nul && docker rm %IMAGE_NAME%

echo ===== 새 컨테이너 실행 =====
docker run -d --name %IMAGE_NAME% -p 8080:8080 %IMAGE_NAME%:%BUILD_NO%
