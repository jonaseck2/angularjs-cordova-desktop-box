#!/usr/bin/env bash

android_sdk="android-sdk_r23.0.2-linux.tgz"
android_sdk_url="http://dl.google.com/android/${android_sdk}"
intel_image="sysimg_x86-19_r01.zip"
intel_image_url="http://download-software.intel.com/sites/landingpage/android/${intel_image}"
android_device="Nexus S"

if [ ! -d "${HOME}/android-sdk-linux/" ] ; then
	
	sudo dpkg --add-architecture i386
	sudo apt-get -qqy update
	sudo apt-get -qqy install libncurses5:i386 libstdc++6:i386 zlib1g:i386

	sudo apt-get -qqy install ant

	echo 'export ANDROID_HOME=${HOME}/android-sdk-linux' >> ${HOME}/.profile
	echo 'export PATH=${PATH}:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools' >> ${HOME}/.profile

	mkdir -vp ${ANDROID_SDK_HOME}
	mkdir -vp /vagrant/.download/
	if [ ! -f "/vagrant/.download/${android_sdk}" ] ; then
		echo "downloading ${android_sdk_url}"
		wget --quiet "${android_sdk_url}" -P /vagrant/.download/
	fi

	tar -xvzf /vagrant/.download/${android_sdk}
fi

	source ${HOME}/.profile

if [ ! -d  "${ANDROID_HOME}/platforms/android-19" ] ; then

	echo y | android update sdk -u --all --filter "platform-tool,android-19,build-tools-19.1.0"

fi

if [ ! -d "${ANDROID_HOME}/system-images/android-19/default/x86" ] ; then
	sudo apt-get -y install unzip

	#download intel x86 android image api level 19
	if [ ! -f "/vagrant/.download/${intel_image}" ] ; then
		echo "downloading ${intel_image_url}"
		wget --quiet ${intel_image_url} -P /vagrant/.download/
	fi

	mkdir -vp ${ANDROID_HOME}/system-images/android-19/default/
	unzip -o /vagrant/.download/${intel_image} -d ${ANDROID_HOME}/system-images/android-19/default/

	if [ `android list avd | wc -l` -le 1 ] ; then
		android -s create avd -n default-19 -t android-19 -b default/x86 -d "${android_device}"
	fi
fi
