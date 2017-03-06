# android-emulator-headress

Dockerコンテナ内でヘッドレスのAndroidエミュレータを立ち上げるサンプル。

`espresso` などを使い `gradle` コマンドにより「画面のテストを行う」ことを前提としたもの。

以下を参考に、数体のDockerfileを合成したもの。(感謝)

- https://github.com/softsam/docker-android-emulator
- https://github.com/ksoichiro/dockerfiles/tree/master/android-emulator

## Built with

- Ubuntu latest
- openjdk 8
- Android SDK 24.3.4
- Android API 19
- ARM

`API 19` に固定しているのは速度の考慮ため。

## Usage

```bash
cd /path/to/project
docker build . -t android-eh
docker run -t -i -v `pwd`:/workspace android-eh start-emulator "./gradlew connectedAndroidTest"
```
