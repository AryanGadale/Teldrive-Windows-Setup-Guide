@echo off
cd /d "C:\teldrive\teldrive-1.8.3-windows-amd64"

:: The -c flag forces Teldrive to use the config in this folder
teldrive.exe run -c config.toml

pause