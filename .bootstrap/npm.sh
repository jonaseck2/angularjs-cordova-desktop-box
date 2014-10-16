#!/usr/bin/env bash

if [ ! -d "${HOME}/.npm-packages" ] ; then
	sudo apt-get -y install python-software-properties python g++ make
	sudo add-apt-repository -y ppa:chris-lea/node.js
	sudo apt-get -y update
	sudo apt-get -y install nodejs

	echo 'NPM_PACKAGES="${HOME}/.npm-packages"' >> ${HOME}/.bash_profile
	echo 'PATH=${PATH}:${NPM_PACKAGES}/bin' >> ${HOME}/.bash_profile
	echo 'NODE_PATH="${NPM_PACKAGES}/lib/node_modules:${NODE_PATH}"' >> ${HOME}/.bash_profile
	echo 'prefix=${HOME}/.npm-packages' >> ${HOME}/.npmrc
	echo 'MANPATH="$NPM_PACKAGES/share/man:$(manpath)"' >> ${HOME}/.bash_profile

	source ${HOME}/.bash_profile

	npm install -g bower grunt-cli yo cordova generator-angularjs-cordova
	#workaround for missing deps when executing cordova build
	npm install -g shelljs q where
fi