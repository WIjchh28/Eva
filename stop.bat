@echo off
setlocal
cd /d "%~dp0"
title Stop Eva Bot

echo [INFO] Menghentikan Eva Bot...

set STOPPED=0
set "BOT_PID="

if exist "runtime\EVA.pid" set /p BOT_PID=<"runtime\EVA.pid"

if defined BOT_PID (
    tasklist /FI "PID eq %BOT_PID%" 2>nul | findstr /i "%BOT_PID%" >nul
    if not errorlevel 1 (
        taskkill /F /T /PID %BOT_PID% >nul 2>&1
        set STOPPED=1
    )
    del /f /q "runtime\EVA.pid" >nul 2>&1
)

:: Fallback jika window Eva Bot masih berjalan
tasklist /FI "WINDOWTITLE eq Eva Bot*" 2>nul | findstr /i /c:"cmd.exe" /c:"node.exe" >nul
if not errorlevel 1 (
    taskkill /F /T /FI "WINDOWTITLE eq Eva Bot*" >nul 2>&1
    set STOPPED=1
)

if "%STOPPED%"=="1" (
    echo [OK] Eva Bot berhasil dihentikan.
) else (
    echo [INFO] Eva Bot sedang tidak berjalan.
)

ping 127.0.0.1 -n 3 >nul
