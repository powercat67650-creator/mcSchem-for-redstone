@echo off
setlocal enabledelayedexpansion
title Minecraft ROM Generator Launcher

set "REQUIRED_JAVA_VERSION=21"
set "LOCAL_JDK_DIR=%~dp0jdk"
set "JAR_NAME=mcschem.jar"

if exist "%LOCAL_JDK_DIR%\bin\java.exe" (
    set "JAVA_CMD=%LOCAL_JDK_DIR%\bin\java.exe"
    goto RUN
)


set "JAVA_CMD="


where java >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%v in ('java -version 2^>^&1 ^| findstr /i "version"') do (
        set "FULL_VER=%%~v"
        for /f "tokens=1 delims=." %%m in ("!FULL_VER!") do set "MAJOR_VER=%%m"
        if "!MAJOR_VER!"=="1" (
            for /f "tokens=2 delims=." %%m in ("!FULL_VER!") do set "MAJOR_VER=%%m"
        )
        if "!MAJOR_VER!" geq "%REQUIRED_JAVA_VERSION%" (
            set "JAVA_CMD=java"
            goto RUN
        )
    )
)

for /d %%D in ("C:\Program Files\Java\*21*" "C:\Program Files\Eclipse Adoptium\*21*") do (
    if exist "%%D\bin\java.exe" (
        set "JAVA_CMD=%%D\bin\java.exe"
        goto RUN
    )
)

set "JDK_URL=https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.2%%2B13/OpenJDK21U-jdk_x64_windows_hotspot_21.0.2_13.zip"
set "ZIP_FILE=%~dp0jdk_temp.zip"

curl -L -o "%ZIP_FILE%" "%JDK_URL%"
if %errorlevel% neq 0 (
    pause
    exit /b 1
)

powershell -Command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%~dp0jdk_tmp' -Force"

for /d %%D in ("%~dp0jdk_tmp\*") do (
    move "%%D" "%LOCAL_JDK_DIR%" >nul
)

rmdir /s /q "%~dp0jdk_tmp"
del /f /q "%ZIP_FILE%"

set "JAVA_CMD=%LOCAL_JDK_DIR%\bin\java.exe"

:RUN
echo.
"%JAVA_CMD%" -jar "%~dp0%JAR_NAME%"
echo.
pause