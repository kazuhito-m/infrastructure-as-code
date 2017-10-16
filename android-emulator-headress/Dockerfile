FROM ubuntu:latest

MAINTAINER kazuhito-m(Twitter:kazuhito_m)

# Install all dependencies
RUN apt-get update && \
    apt-get install -y wget openjdk-8-jdk-headless libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 zlib1g lib32z1 git redir && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Install android tools + sdk
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH $PATH:${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools

# Set up insecure default key
RUN mkdir -m 0750 /.android
ADD resources/insecure_shared_adbkey /.android/adbkey
ADD resources/insecure_shared_adbkey.pub /.android/adbkey.pub

RUN wget -qO- "http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz" | tar -zx -C /opt && \
    echo y | android update sdk --no-ui --all --filter platform-tools --force

RUN mkdir -m 0750 "$ANDROID_HOME/licenses/"
RUN echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55\n\nd56f5187479451eabf01fb78af6dfcb131a6481e" > "$ANDROID_HOME/licenses/android-sdk-license"
RUN echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "$ANDROID_HOME/licenses/android-sdk-preview-license"

# Expose android port
EXPOSE 5555
# VNC port
EXPOSE 5900

# Needed to be able to run VNC - bug of Android SDK
RUN mkdir ${ANDROID_HOME}/tools/keymaps && touch ${ANDROID_HOME}/tools/keymaps/en-us

# Install dependencies for emulator
RUN echo y | android update sdk --no-ui --all -t `android list sdk --all|grep "SDK Platform Android 5.0.1, API 21"|awk -F'[^0-9]*' '{print $2}'` && \
    echo y | android update sdk --no-ui --all -t `android list sdk --all|grep "ARM EABI v7a System Image, Android API 21, revision 4"|awk -F'[^0-9]*' '{print $2}'` --force

RUN echo n | android create avd --force -n "arm" -t android-21 --abi default/armeabi-v7a -c 100M -s WVGA800

# Avoid emulator assumes HOME as '/'.
ENV HOME /root
ADD scripts/wait-for-emulator /usr/local/bin/
ADD scripts/start-emulator /usr/local/bin/
ADD scripts/init-emulator /usr/local/bin/

# 暖機運転(anrdoidのJavaProjectを作り、ビルド、キャッシュを貯める)
# RUN mkdir -p /opt/tmp && android create project -g -v 0.9.+ -a MainActivity -k com.example.example -t android-19 -p /opt/tmp
# 上記をやりたかったが、android-sdkのバグでコケるため「完成品のgradleプロジェクトサンプル」を送り込んで実行。
RUN mkdir /opt/tmp/
ADD resources/sample-proj.tgz /opt/tmp/
# ADDの効力で、tgzは展開されているはず
RUN cd /opt/tmp/sample-proj && ./gradlew task clean test
RUN rm -rf /opt/tmp

VOLUME /workspace
WORKDIR /workspace
