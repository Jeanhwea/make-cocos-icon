@echo off
setlocal enabledelayedexpansion

echo Starting application packaging...

:: Get Git tag
git describe --tags --always --dirty="+dev" > git_tag.tmp
set /p GIT_TAG=<git_tag.tmp
del git_tag.tmp

:: Get operating system information
set OS_NAME=Windows
set OS_ARCH=x86_64

:: Set output directory
set OUT_DIR=output
set DST_DIR=dist

:: Create destination directory if it doesn't exist
if not exist "%DST_DIR%" mkdir "%DST_DIR%"

:: Jump to the main execution section to avoid directly executing the function
goto :main

:: Define the packaging function
:package_app
setlocal enabledelayedexpansion
set APP_PKG=%1
set APP_ENT=%2
set OUT_EXE=!OUT_DIR!\!APP_PKG!.exe
set OUT_ZIP=!DST_DIR!\!APP_PKG!-!OS_NAME!-!OS_ARCH!-!GIT_TAG!.zip

echo Packaging !APP_PKG! from !APP_ENT!...

:: Clean old build files for this app
if exist "!OUT_DIR!" rmdir /s /q "!OUT_DIR!"
mkdir "!OUT_DIR!"

:: Build application
echo Building application with Nuitka...
uv run python -m nuitka --assume-yes-for-downloads --include-windows-runtime-dlls=no !APP_ENT! --output-dir=!OUT_DIR!

:: Check if build was successful
if !errorlevel! neq 0 (
    echo Build failed for !APP_PKG!!
    endlocal
    exit /b !errorlevel!
)

:: Check if EXE directory exists
if not exist "!OUT_EXE!" (
    echo Error: Executable directory !OUT_EXE! was not created!
    endlocal
    exit /b 1
)

:: Compress file
echo Compressing file...

:: Package into ZIP file
set OUT_FILE=%OUT_ZIP%
powershell Compress-Archive -Path "!OUT_EXE!" -DestinationPath "!OUT_FILE!" -Force
if errorlevel 1 (
    echo. ZIP packaging failed.
    exit /b 1
)

echo Packaging completed, output file: !OUT_FILE!

:: Clean output directory
if exist "%OUT_DIR%" rd /s /q "%OUT_DIR%"

echo Packaging completed for !APP_PKG!!
echo Output file: !OUT_ZIP!
endlocal
goto :eof

:: Main execution section
:main
:: Package both applications
call :package_app make-cocos-icon main.py
if %errorlevel% neq 0 (
    echo Failed to package make-cocos-icon
    exit /b %errorlevel%
)

echo All applications packaged successfully!
endlocal
