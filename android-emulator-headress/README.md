# android-emulator-headress

Dockerコンテナ内でヘッドレスのAndroidエミュレータを立ち上げるサンプル。

`espresso` などを使い `gradle` コマンドにより「画面のテストを行う」ことを前提としたもの。

以下を参考に、数体のDockerfileを合成したもの。(感謝)

- https://github.com/softsam/docker-android-emulator
- https://github.com/ksoichiro/dockerfiles/tree/master/android-emulator

## Built with

- Ubuntu latest
- openjdk 8
- Android SDK 24.4.1
- Android API 21
- ARM

## Usage

```bash
docker build . -t android-emulator-image

cd /path/to/android-project
docker run -t -i -v `pwd`:/workspace android-emulator-image start-emulator "./gradlew connectedAndroidTest"
```
