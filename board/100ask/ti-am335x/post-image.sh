#!/bin/sh

BOARD_DIR="$(dirname $0)"

# copy the uEnv.txt to the output/images directory
cp  board/100ask/ti-am335x/uEnv.txt $BINARIES_DIR/uEnv.txt
mkimage -A arm -O linux -T ramdisk -C none -a 0x88080000 -n "ramdisk" -d $BINARIES_DIR/rootfs.cpio.gz $BINARIES_DIR/ramdisk.gz


GENIMAGE_CFG="${BOARD_DIR}/genimage.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

rm -rf "${GENIMAGE_TMP}"

genimage \
    --rootpath "${TARGET_DIR}" \
    --tmppath "${GENIMAGE_TMP}" \
    --inputpath "${BINARIES_DIR}" \
    --outputpath "${BINARIES_DIR}" \
    --config "${GENIMAGE_CFG}" > /dev/null

mkdir -p  output/images/nfs_rootfs
mkdir -p  output/images/Nandflash_system
mv output/images/rootfs.tar.gz  	output/images/nfs_rootfs
mv output/images/rootfs.ubi   		output/images/Nandflash_system
cp output/images/MLO  		  		output/images/Nandflash_system
cp output/images/u-boot.img   		output/images/Nandflash_system
cp output/images/uEnv.txt     		output/images/Nandflash_system
cp output/images/zImage				output/images/Nandflash_system
cp output/images/100ask-am335x.dtb  output/images/Nandflash_system

echo "-------------------------------------------------------"

echo " Uboot  image:  		 `ls -lh  output/images/MLO`"
echo " Uboot  image:  		 `ls -lh  output/images/u-boot.img`"
echo " Uboot  image:  		 `ls -lh  output/images/uEnv.txt` "

echo " Linux kernel   image:  	 `ls -lh output/images/zImage`"
echo " Linux kernel   image:  	 `ls -lh output/images/100ask-am335x.dtb`  \033[0m"

echo " nfs   rootfs   files:  	 `ls -lh output/images/nfs_rootfs/*`"

echo "                                                               "
echo " SDcard system  image:     `ls -lh  output/images/sdcard.img ` "

echo " Nandflash system image:   `ls -lh  output/images/Nandflash_system/MLO`"
echo " Nandflash system image:   `ls -lh  output/images/Nandflash_system/u-boot.img`"
echo " Nandflash system image:   `ls -lh  output/images/Nandflash_system/uEnv.txt  `"
echo " Nandflash system image:   `ls -lh  output/images/Nandflash_system/zImage`"
echo " Nandflash system image:   `ls -lh  output/images/Nandflash_system/100ask-am335x.dtb`"
echo " Nandflash system image:   `ls -lh  output/images/Nandflash_system/rootfs.ubi`"


echo "\033[32m Successful system construction!   \033[0m"
