#!/bin/bash
device='AlpsPS/2 ALPS GlidePoint'
state=$(xinput list-props 'AlpsPS/2 ALPS GlidePoint' | grep 'Device Enabled' | cut -f3)

echo $device
echo $state

if [ $state == 1 ]; then
    xinput --disable "AlpsPS/2 ALPS GlidePoint"
else
    xinput --enable "AlpsPS/2 ALPS GlidePoint"
fi

