#!/bin/sh

#Get the way to start the device 
LINE=$(cat /proc/cmdline )
VAR=$(echo ${LINE:22:10} | awk '{print $1}')
# Get the process pid by name
PIDS=$(ps -A |grep "am335x_app"| awk '{print $1}')
UBI='root=ubi0'

if [ $VAR = $UBI ]; then
        dd  if=/dev/zero  of=/root/disk.img  bs=1M  count=10 > /dev/null
        mkdosfs  /root/disk.img
        mount -t vfat -o sync  /root/disk.img  /arduino
        modprobe  g_mass_storage file=/root/disk.img  removable=1
else
	mkdosfs  /dev/mmcblk0p3
	
	mount -t vfat   /dev/mmcblk0p3  /arduino
	modprobe  g_mass_storage file=/dev/mmcblk0p3   removable=1
	
fi

mkdir -p /arduino/arduino-100ask
MYFILE=/arduino/arduino-100ask/am335x_app
while :
do
        find /arduino/ -name "am335x*" > /dev/null

if [ -f "/arduino/arduino-100ask/am335x_app" ]
then
        mv /arduino/arduino-100ask/am335x_app  /root
        chmod u+x /root/am335x_app
        echo -e "\033[32m Application copy succeeded ! \033[0m"
        cd /root
fi
        sleep 3
done
