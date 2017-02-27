FROM ubuntu:latest

# Android Emurator をDocker内で動かすサンプル。
# https://github.com/softsam/docker-android-emulator を参考にいろいろ合成。
# AndroidのAPIバージョンを19に固定してあるのは、スピード対策。

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
ADD files/insecure_shared_adbkey /.android/adbkey
ADD files/insecure_shared_adbkey.pub /.android/adbkey.pub

RUN wget -qO- "http://dl.google.com/android/android-sdk_r24.3.4-linux.tgz" | tar -zx -C /opt && \
    echo y | android update sdk --no-ui --all --filter platform-tools --force

RUN mkdir -m 0750 "$ANDROID_HOME/licenses/"
RUN echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "$ANDROID_HOME/licenses/android-sdk-license"
RUN echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "$ANDROID_HOME/licenses/android-sdk-preview-license"

# Expose android port
EXPOSE 5555
# VNC port
EXPOSE 5900

# Needed to be able to run VNC - bug of Android SDK
RUN mkdir ${ANDROID_HOME}/tools/keymaps && touch ${ANDROID_HOME}/tools/keymaps/en-us

# Install dependencies for emulator
RUN echo y | android update sdk --no-ui --all -t `android list sdk --all|grep "SDK Platform Android 4.4.2, API 19"|awk -F'[^0-9]*' '{print $2}'` && \
    echo y | android update sdk --no-ui --all -t 98 --force

RUN echo n | android create avd --force -n "arm" -t android-19 --abi default/armeabi-v7a -c 100M -s WVGA800

# Add script
ADD scripts/start.sh /start.sh
RUN chmod +x /start.sh
CMD /start.sh
