#!/bin/bash

now=`date`
up=`uptime -p`
current="$now
${up^}"
notify-send "$current"
