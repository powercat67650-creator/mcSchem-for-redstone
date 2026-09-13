@echo off
setlocal enabledelayedexpansion
title Minecraft ROM Generator Launcher

:: Configuration
set "REQUIRED_JAVA_VERSION=21"
set "LOCAL_JDK_DIR=%~dp0jdk"
set "JAR_NAME=mcschem.jar"

echo [?] Verification de l'environnement Java...

:: 1. Verifier si un JDK local existe deja dans le dossier /jdk
if exist "%LOCAL_JDK_DIR%\bin\java.exe" (
    echo [+] JDK local trouve dans %LOCAL_JDK_DIR%
    set "JAVA_CMD=%LOCAL_JDK_DIR%\bin\java.exe"
    goto RUN
)

:: 2. Rechercher Java 21 dans le PATH ou dans Program Files
set "JAVA_CMD="

:: Test de la commande 'java' globale du systeme
where java >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%v in ('java -version 2^>^&1 ^| findstr /i "version"') do (
        set "FULL_VER=%%~v"
        for /f "tokens=1 delims=." %%m in ("!FULL_VER!") do set "MAJOR_VER=%%m"
        if "!MAJOR_VER!"=="1" (
            for /f "tokens=2 delims=." %%m in ("!FULL_VER!") do set "MAJOR_VER=%%m"
        )
        if "!MAJOR_VER!" geq "%REQUIRED_JAVA_VERSION%" (
            echo [+] Java !MAJOR_VER! detecte sur le systeme.
            set "JAVA_CMD=java"
            goto RUN
        )
    )
)

:: 3. Recherche automatique dans "C:\Program Files\Java" et Eclipse Adoptium
for /d %%D in ("C:\Program Files\Java\*21*" "C:\Program Files\Eclipse Adoptium\*21*") do (
    if exist "%%D\bin\java.exe" (
        echo [+] JDK 21 trouve dans %%D
        set "JAVA_CMD=%%D\bin\java.exe"
        goto RUN
    )
)

:: 4. Aucun JDK 21 valide trouve -> Telechargement du JDK 21 Temurin (Portable)
echo [!] Aucun JDK %REQUIRED_JAVA_VERSION% detecte.
echo [!] Telechargement automatique d'un JDK 21 portable (Eclipse Temurin)...

set "JDK_URL=https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.2%%2B13/OpenJDK21U-jdk_x64_windows_hotspot_21.0.2_13.zip"
set "ZIP_FILE=%~dp0jdk_temp.zip"

:: Telechargement via curl (integre nativement dans Windows 10/11)
curl -L -o "%ZIP_FILE%" "%JDK_URL%"
if %errorlevel% neq 0 (
    echo [X] Erreur lors du telechargement du JDK. Verifiez votre connexion Internet.
    pause
    exit /b 1
)

echo [+] Extraction du JDK...
:: Extraction du ZIP en PowerShell dans le dossier temp
powershell -Command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%~dp0jdk_tmp' -Force"

:: Deplacement du dossier extrait vers /jdk
for /d %%D in ("%~dp0jdk_tmp\*") do (
    move "%%D" "%LOCAL_JDK_DIR%" >nul
)

:: Nettoyage des fichiers temporaires
rmdir /s /q "%~dp0jdk_tmp"
del /f /q "%ZIP_FILE%"

set "JAVA_CMD=%LOCAL_JDK_DIR%\bin\java.exe"
echo [+] Installation du JDK local terminee avec succes !

:RUN
echo.
echo [ Lancement de %JAR_NAME%...
echo --------------------------------------------------
"%JAVA_CMD%" -jar "%~dp0%JAR_NAME%"
echo --------------------------------------------------
echo.
pause