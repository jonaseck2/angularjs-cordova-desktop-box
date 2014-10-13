#!/usr/bin/env bash

webstorm_url="http://download.jetbrains.com/webstorm/WebStorm-8.0.4.tar.gz"

#Install java8
add-apt-repository -y ppa:webupd8team/java 
apt-get -y update
echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
apt-get -qq -y install oracle-java8-installer oracle-java8-set-default



#Install WebStorm
if [ ! -d "/vagrant/.download/`basename \"${webstorm_url}\"`" ] ; then
	mkdir -vp /vagrant/.download/
	wget --quiet "${webstorm_url}" -P /vagrant/.download/
fi


#if [ ! -d "${HOME}/android-sdk-linux/" ] ; then
	
	
	#echo 'export ANDROID_SDK_HOME=/vagrant/' >> ${HOME}/.bash_profile
	#echo "export ANDROID_HOME=${HOME}/android-sdk-linux" >> ${HOME}/.bash_profile
	#echo 'export PATH=${PATH}:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools' >> ${HOME}/.bash_profile
	#echo 'export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-i386' >> ${HOME}/.bash_profile
	
	#source ${HOME}/.bash_profile

	#mkdir -vp ${ANDROID_SDK_HOME}
	#mkdir -vp /vagrant/.download/
	#if [ ! -f "/vagrant/.download/${android_sdk}" ] ; then
	#	echo "downloading ${android_sdk_url}"
	#	wget --quiet "${android_sdk_url}" -P /vagrant/.download/
	#fi

	tar -xvzf /vagrant/.download/${android_sdk}
#fi


apt-get -y install git

