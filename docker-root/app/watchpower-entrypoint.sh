#!/bin/bash
export HOME="/home/user"
#export DISPLAY=:11

export

# Wait for app to start, then resize to fill screen and exit...
bash -c 'while : ; do sleep 1 && wmctrl -r WatchPower -b add,fullscreen ; done' &

xterm

# # Program is somewhat unreliable - continually restart if it crashes...
# while : ; do
#     cd /app/linux*/WatchPower && ./WatchPower
#     sleep 5
# done;

# http://localhost:9981/?password=watchpower&autoconnect=true&reconnect=true&resize=remote&reconnect_delay=1000