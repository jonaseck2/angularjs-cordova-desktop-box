#!/usr/bin/env bash

if [ ! -d "${HOME}/.npm-packages" ] ; then
	sudo apt-get -qqy install python-software-properties python g++ make
	sudo add-apt-repository -y ppa:chris-lea/node.js
	sudo apt-get -qqy update
	sudo apt-get -qqy install nodejs

	echo 'export NPM_PACKAGES="${HOME}/.npm-packages"' >> ${HOME}/.profile
	echo 'export PATH=${PATH}:${NPM_PACKAGES}/bin' >> ${HOME}/.profile
	echo 'export NODE_PATH="${NPM_PACKAGES}/lib/node_modules:${NODE_PATH}"' >> ${HOME}/.profile
	echo 'prefix=${HOME}/.npm-packages' >> ${HOME}/.npmrc
	echo 'export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"' >> ${HOME}/.profile

	source ${HOME}/.profile

	npm install -g bower grunt-cli yo cordova generator-angularjs-cordova
	#workaround for missing deps when executing cordova build
	npm install -g shelljs q where
fi