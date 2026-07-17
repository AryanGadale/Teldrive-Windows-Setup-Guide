@echo off
set "URL=%~1"
set "URL=%URL:vlc://=%"
set "URL=%URL:http//=http://%"
set "URL=%URL:https//=https://%"
start "" "C:\Program Files\VideoLAN\VLC\vlc.exe" "%URL%"