@echo off

set APP_PKG=make-cocos-icon

REM Get Git tag information
for /f "tokens=*" %%a in ('git describe --tags --always') do set GIT_TAG=%%a

REM Get Windows system architecture information
set OS_NAME=Windows

for /f "tokens=*" %%a in ('uname -m') do set OS_ARCH=%%a
REM Remove spaces from OS_ARCH
set OS_ARCH=%OS_ARCH: =%

set OUT_DIR=output
set ZIP_DIR=%OUT_DIR%
set ZIP_IMG=%APP_PKG%-%OS_NAME%-%OS_ARCH%-%GIT_TAG%.zip

uv run python -m nuitka main.py

cd output

REM Use PowerShell to create ZIP file
powershell -Command "Compress-Archive -Path %APP_PKG%.exe -DestinationPath %ZIP_IMG% -Force"

cd ..
