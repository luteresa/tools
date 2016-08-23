#!/bin/sh

# 删除存在的调试文件
rm -rf /mnt/cfg/ext/de_core*
		
APP_PREV_PATH=/mnt/mtd/nfsdir/bin
if [ -f /mnt/mtd/nfsdir/bin/app/ipcamera ]
then
	APP_PREV_PATH=/mnt/mtd/nfsdir/bin
elif [ -f /mnt/mtd/bin/app/ipcamera ]
then
	APP_PREV_PATH=/mnt/mtd/bin
else
	echo "current no ipcamera exe"
	exit 0
fi

if ! [ -f /mnt/cfg/ext/server.js ];
then
	cp -f /etc/empty /mnt/cfg/ext/server.js
fi

if ! [ -f /mnt/cfg/ext/resolv.conf ];
then
	cp -f /etc/empty /mnt/cfg/ext/resolv.conf
fi

cp -f /mnt/mtd/etc/udhcpc.script /tmp_run/
chmod +x /tmp_run/udhcpc.script

cd /tmp_run
rm -rf snmp
mkdir snmp
ln -s ${APP_PREV_PATH}/app/snmp/snmpd /tmp_run/snmp/snmpd

rm -rf WebPage
ln -s ${APP_PREV_PATH}/app/WebPage /tmp_run/WebPage
ln -s ${APP_PREV_PATH}/app/UDZK16_16.dzk /tmp_run/UDZK16_16.dzk


#增加image.bin的路径链接
rm -f /tmp_run/image.bin
if [ -f /mnt/cfg/ext/image.bin ];
then
	ln -s /mnt/cfg/ext/image.bin /tmp_run/image.bin
else
	ln -s ${APP_PREV_PATH}/app/image.bin /tmp_run/image.bin
fi

rm -f /tmp_run/ipcamera
ln -s ${APP_PREV_PATH}/app/ipcamera /tmp_run/ipcamera

#pppoe ln
rm -rf /tmp_run/pppoe
mkdir /tmp_run/pppoe
ln -s ${APP_PREV_PATH}/app/pppoe/adsl-connect /tmp_run/pppoe/adsl-connect
ln -s ${APP_PREV_PATH}/app/pppoe/adsl-start /tmp_run/pppoe/adsl-start
ln -s ${APP_PREV_PATH}/app/pppoe/adsl-stop /tmp_run/pppoe/adsl-stop
ln -s ${APP_PREV_PATH}/app/pppoe/adsl-setup /tmp_run/pppoe/adsl-setup
ln -s ${APP_PREV_PATH}/app/pppoe/adsl-status /tmp_run/pppoe/adsl-status
ln -s ${APP_PREV_PATH}/app/pppoe/pppd /tmp_run/pppoe/pppd
ln -s ${APP_PREV_PATH}/app/pppoe/pppoe /tmp_run/pppoe/pppoe

if ! [ -d /mnt/cfg/ext/ppp ];
then
    mkdir /mnt/cfg/ext/ppp
fi

rm -rf /tmp_run/pppoe/ppp
mkdir /tmp_run/pppoe/ppp

rm -f /mnt/cfg/ext/ppp/*
cp -rf ${APP_PREV_PATH}/app/pppoe/ppp/* /tmp_run/pppoe/ppp

#######################################################################
#######################################################################

# 启动驱动
cd ${APP_PREV_PATH}/ko &&  ./load3518e -i ar0130

# 保存配置参数
if  [ -f ${APP_PREV_PATH}/config/FacConf -a ! -f /mnt/mtd/nfsdir/FacConf ];
then
    cp -f ${APP_PREV_PATH}/config/FacConf /mnt/mtd/nfsdir/FacConf
fi

if [ ! -d /mnt/mtd/flash/defCfgDir ];
then
    mkdir /mnt/mtd/flash/defCfgDir
fi

if [ -d ${APP_PREV_PATH}/config ];
then
    if [ -f ${APP_PREV_PATH}/config/alarmCfg.xml ];
    then
        cp -f ${APP_PREV_PATH}/config/alarmCfg.xml /mnt/mtd/flash/defCfgDir
    fi

    if [ -f ${APP_PREV_PATH}/config/netCfg.xml ];
    then
        cp -f ${APP_PREV_PATH}/config/netCfg.xml /mnt/mtd/flash/defCfgDir
    fi

    if [ -f ${APP_PREV_PATH}/config/avCfg.xml ];
    then
        cp -f ${APP_PREV_PATH}/config/avCfg.xml /mnt/mtd/flash/defCfgDir
    fi

    if [ -f ${APP_PREV_PATH}/config/baseCfg.xml ];
    then
        cp -f ${APP_PREV_PATH}/config/baseCfg.xml /mnt/mtd/flash/defCfgDir
    fi

    if [ -f ${APP_PREV_PATH}/config/ptzCfg.xml ];
    then
        cp -f ${APP_PREV_PATH}/config/ptzCfg.xml /mnt/mtd/flash/defCfgDir
    fi
fi

mdev -s
echo /sbin/mdev > /proc/sys/kernel/hotplug

export LD_LIBRARY_PATH="${APP_PREV_PATH}/app/:$LD_LIBRARY_PATH"

# 这里可能有问题，暂时不处理
# software reset
#if [ -f /mnt/cfg/ext/ResetFlag ]
#then
#		echo "rm mnt cfg ext ResetFlag"
#    rm -f /mnt/cfg/ext/ResetFlag
#    rm -f /mnt/mtd/flash/*
#fi

if [ -f ${APP_PREV_PATH}/FacConf ]
then
	cp -f ${APP_PREV_PATH}/FacConf  /mnt/cfg/flash/FacConf
fi

# 制作文件系统的时候 ln -s /tmp_run/leftPicture.png ${APP_PREV_PATH}/app/WebPage/Css/Pictures/Login/leftPicture.png
#                    ln -s /tmp_run/logo.png ${APP_PREV_PATH}/app/WebPage/Css/Pictures/Login/logo.png
# 这两个文件是可以更新的 如果有更新则需要重新拷贝
rm -rf /tmp_run/leftPicture.png
if [ -f /mnt/mtd/nfsdir/login_logo.png ]
then
	ln -s /mnt/mtd/nfsdir/login_logo.png /tmp_run/leftPicture.png
else
	if [ -f ${APP_PREV_PATH}/app/WebPage/Css/Pictures/Login/login_logo.png ]
	then
		ln -s ${APP_PREV_PATH}/app/WebPage/Css/Pictures/Login/login_logo.png /tmp_run/leftPicture.png
	fi
fi      

rm -f /tmp_run/logo.png
if [ -f /mnt/mtd/nfsdir/title_logo.png ]  
then                                             
	ln -s /mnt/mtd/nfsdir/title_logo.png /tmp_run/logo.png
else 
	if [ -f ${APP_PREV_PATH}/app/WebPage/Css/Pictures/title_logo.png ]
	then
		ln -s ${APP_PREV_PATH}/app/WebPage/Css/Pictures/title_logo.png /tmp_run/logo.png
	fi
fi

#if [ -f /mnt/mtd/nfsdir/certKey.spc ] && [ -f /mnt/mtd/nfsdir/certKey.pem ]
#then
#	/tmp_run/osslsigncode remove-signature -in /tmp_run/WebPage/SuperClientEx.exe -out /tmp_run/WebPage/SuperClientEx2.exe
#	rm -f /tmp_run/WebPage/SuperClientEx.exe
#	/tmp_run/osslsigncode sign -certs /mnt/mtd/nfsdir/certKey.spc -key /mnt/mtd/nfsdir/certKey.pem -in /tmp_run/WebPage/SuperClientEx2.exe -out /tmp_run/WebPage/SuperClientEx.exe
#	rm -f /tmp_run/WebPage/SuperClientEx2.exe
#fi

echo 1451 > /proc/sys/kernel/threads-max
ulimit -n 2048
ulimit -p 725

BUG_CHK_FILE_NAME=/mnt/cfg/ext/debug.dat
if [ -f ${BUG_CHK_FILE_NAME} ]
then
	DEBUG_FLAG_INFO=`cat ${BUG_CHK_FILE_NAME}`
	if [ "debugx" = "${DEBUG_FLAG_INFO}x" ]
	then
		# 只能存放flash上，所以只能定义1M文件大小
		ulimit -c unlimited
		#ulimit -c 1024
		echo 1 > /proc/sys/kernel/core_uses_pid
		echo "/mnt/cfg/ext/de_core-%e-%p-%t" > /proc/sys/kernel/core_pattern
		
		# 增加cpu信息保存
		sh ${APP_PREV_PATH}/app/sa_info.sh 2 &
		
	fi
fi

cd /tmp_run/
/tmp_run/ipcamera reset
/tmp_run/ipcamera cmdserver&
/tmp_run/ipcamera &

# 增加调试信息
#if [ -f ${APP_PREV_PATH}/app/sa_info.sh ]
#then
	# 检测ip地址是否更改，因为没有更改则mount出问题
#	sh ${APP_PREV_PATH}/app/sa_info.sh 3
	
	# 检测debug信息是否正常
#	sh ${APP_PREV_PATH}/app/sa_info.sh 1
	
	# 增加cpu信息保存
#	sh ${APP_PREV_PATH}/app/sa_info.sh 2 &
#fi

