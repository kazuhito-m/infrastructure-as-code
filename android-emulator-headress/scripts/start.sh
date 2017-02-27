#!/bin/bash
ip=$(ip addr list eth0|grep "inet "|cut -d' ' -f6|cut -d/ -f1)
redir --laddr=$ip --lport=5555 --caddr=127.0.0.1 --cport=5555 &

# Set up and run emulator
# emulator64-${android_arch} -avd ${android_arch} -http-proxy "$http_proxy" -noaudio -no-window -gpu off -verbose3 -qemu -vnc :0
emulator64-arm -avd arm -noaudio -no-window -gpu off -verbose -qemu -vnc :0 &

# スリープとかかましたあとに、以下を実行。
# adb shell 'setprop persist.sys.locale ja; setprop persist.sys.timezone "Asia/Tokyo"; setprop persist.sys.country JP; setprop persist.sys.language ja; stop; start'
