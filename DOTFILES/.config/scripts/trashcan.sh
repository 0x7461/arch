#!/bin/sh
echo "*** TRASH CAN ***"

TRASHCAN=/home/ta/.local/share/Trash

if [ ! -d "$TRASHCAN" ]; then
	# create Trash and then echo back
	if  mkdir -p "$TRASHCAN"; then
		echo "No trash can, i created one!"
	else
		echo "No trash can, i tried to create one but failed!"
		exit 1
	fi
else
	# check for size of trash can, then echo back
	TRASHCANINFO=`du --summarize "$TRASHCAN"`
	TRASHSIZE=`echo "${TRASHCANINFO}" | sed "s/\s.*//"`
	echo "Size: ${TRASHSIZE} KiB"
fi

read -p "Empty trash can? (y/n) " option


if [ "$option" == "y" ]; then
	# clean trash
	echo "Cleaning..."
	rm -rf /home/ta/.local/share/Trash/*
	echo "Done!"
	exit 0
elif [ "$option" == "n" ]; then
	echo "Exiting..."
	exit 0
else
	echo "That's not an option! Exiting..."
	exit 1
fi
