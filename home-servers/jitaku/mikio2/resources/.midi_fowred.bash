#!/bin/bash

# 2016/01/11 kazuhito add.
# midiport fowerding
 
ps aux | grep 'timidity' | grep -v grep > /dev/null
if [ $? = 1 ]; then
	timidity --sequencer-ports=1 -iAD
	sleep 1
	aconnect 14:0 128:0 &
fi


