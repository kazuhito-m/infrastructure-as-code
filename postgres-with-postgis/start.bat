REM kickしたフォルダから、このスクリプトのあるフォルダに移動。
cd /D %~dp0

docker-compose up -d --build