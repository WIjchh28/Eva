@echo off
setlocal
cd /d "%~dp0"
title Eva Bot Launcher

if not exist "runtime" mkdir "runtime"

for /f "usebackq delims== tokens=1,2" %%A in (".env") do (
    set "%%A=%%B"
)

set "OLD_PID="
if exist "runtime\EVA.pid" set /p OLD_PID=<"runtime\EVA.pid"

if defined OLD_PID (
    tasklist /FI "PID eq %OLD_PID%" 2>nul | findstr /i "%OLD_PID%" >nul
    if not errorlevel 1 (
        echo [INFO] Eva Bot sudah aktif [PID: %OLD_PID%].
        ping 127.0.0.1 -n 3 >nul
        exit /b
    )
)

echo [INFO] Memulai Eva Bot...
echo [INFO] Model AI: %MODEL% (Router: %ROUTER_BASE_URL%)
powershell -NoProfile -ExecutionPolicy Bypass -Command "$proc = Start-Process -FilePath 'cmd.exe' -ArgumentList '/k title Eva Bot && node index.js' -WorkingDirectory '%~dp0' -PassThru; $proc.Id | Out-File -FilePath 'runtime\EVA.pid' -Encoding ascii -Force"

set "BOT_PID="
if exist "runtime\EVA.pid" set /p BOT_PID=<"runtime\EVA.pid"

if defined BOT_PID (
    echo [OK] Eva Bot berhasil dijalankan [PID: %BOT_PID%].
) else (
    echo [ERROR] Gagal memulai Eva Bot.
)

ping 127.0.0.1 -n 3 >nul
