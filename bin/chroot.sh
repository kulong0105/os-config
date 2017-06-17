#!/bin/sh

if [ $# = 2 ]; then
	mount $1 $2 || exit
	shift
fi

mnt=$1

mount --bind /sys $mnt/sys
mount --bind /dev $mnt/dev 
mount --bind /proc $mnt/proc

chroot $mnt
