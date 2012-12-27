@echo off

echo Welcome to the opportunity to free your Thrive!
echo.
echo Originally developed by TYBAR at the Thrive forums,
echo this tool pushes several files onto your device,
echo then flashes the unlocked bootloader, then
echo installs the SU binary and Superuser app.
echo.
echo I am not responsible if you break your tablet, you
echo were the one that ran this. In the off chance that
echo something does happen, please PM me, pio_masaki,
echo or dalepl for help. Also, I am completely not 
echo responsible for pixies flying out of your HDMI
echo port, either. ;)
echo.
echo Please connect your tablet now, or exit to keep
echo a full stock Thrive.

pause

cd roottool
adb wait-for-device
adb shell "mv /data/gps/gldata.sto /data/gps/gldata.sto.bak"
adb shell "ln -s /data/local.prop /data/gps/gldata.sto"
echo Fire up Google maps. Wait for the GPS icon to have
echo full lock before continuing. Then hit the Home button.
echo.
echo You may disconnect your device for the moment, but
echo you need to reconnect it before continuing.
echo.
echo At this time, the script cannot check if the file got
echo into place, so let the script run fully before trying
echo to exit out if it didn't work.
pause
adb shell "mv /data/gps/gldata.sto.bak /data/gps/gldata.sto"
adb shell "echo "ro.kernel.qemu=1" > /data/local.prop"
adb shell "echo "ro.sys.atvc_allow_all_adb=1" >> /data/local.prop"
adb reboot

adb wait-for-device
 
adb shell "mkdir /data/x-root"
adb shell "mkdir /data/x-root/bin"


adb push busybox /data/x-root/bin/busybox
adb push su /data/x-root/bin/su
adb shell "cd /data/x-root/bin"
adb shell "chmod 755 busybox"
adb shell "PATH="${PATH}:/data/x-root/bin"; export PATH"
adb shell "./busybox mknod /dev/loop0 b 7 0"
adb shell "./busybox losetup -o 20971520 /dev/loop0 /dev/block/mmcblk0"
adb shell "mkdir /dev/tmpdir"
adb shell "./busybox mount -t ext4 /dev/loop0 /dev/tmpdir"
adb shell "./busybox cp /data/x-root/bin/su /dev/tmpdir/bin/"
adb shell "chmod 4555 /dev/tmpdir/bin/su"
adb shell "umount /dev/tmpdir"
adb shell sync
adb shell "echo "ro.kernel.qemu=0" > /data/local.prop"
adb reboot

echo Now we need to install "SuperUser" from the Play store.
echo Free version is fine.
echo Please run it in order for root to work. We need
echo it to continue.
echo.
echo If it does not install, please let us know on the
echo Thrive forums.
echo.
echo If you do continue, make sure that both your computer
echo and tablet don't power off. What we are doing, if
echo interrupted, could fry your tablet permanently.
pause
adb push blob /mnt/sdcard0/blob
adb push recovery.img /mnt/sdcard0/recovery.img
adb shell su
echo If 
adb shell dd if=/mnt/sdcard0/blob of=/dev/block/mmcblk0p6
adb shell dd if=/mnt/sdcard0/recovery.img of=/dev/block/mmcblk0p1
echo Let's check that recovery did flash and that the new bootloader
echo isn't giving us the finger running it
adb reboot
echo To get to recovery, Hold Volume + and select recovery 

echo Grats, should now be running a fully open system.
echo Flash away!
echo Credit goes to pio_masaki, Walking_corpse, and AmEv for
echo testing and building this script.
pause



