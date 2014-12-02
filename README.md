# angularjs-cordova-desktop-box #

A Lubuntu based **vagrant** box provisioned with the cordova development environment for the **android** platform. **All you have to do** is to clone the repository, fire `vagrant up` and add your android device to VirtualBox. After that you are ready to begin your cordova project.

This box is configured to work with the yeoman generator **generator-angularjs-cordova** and adds the tools required to generate a skeleton project.

## Installation ##

### 1) Download and install the box ###

1. install vagrant http://docs.vagrantup.com/v2/installation/index.html
2. run `git clone https://github.com/jonaseck2/angularjs-cordova-box.git`
3. run `cd angularjs-cordova-box`
3. run `vagrant up`

#### Note for Windows hosts:
npm commands on shared folders do not work, even with symlink support or --no-bin-links. Currently the only workaround is to install npm in windows and run the commands on the windows host. Copying or cloning the generated project to a windows share and running npm install works fine.

### 2) Configure your device on the box ###

0. Plug the device
1. VirtualBox -> angularjs-cordova-box -> Settings -> Ports -> USB -> Add Filter -> (Select your android device)
2. (your device) Settings -> Developer Options -> USB Debugging (remark if it alreday marked)
3. (your device) A prompt to allow the virtual machine will appear. Click ok.
4. Plug and unplug the USB device.
5. (vagrant) run `adb devices`. You now should see your device on the list. 

In order to resolve the `?????? no permissions` problem:

* sudo -s
* adb kill-server
* adb start-server
* adb devices

### 3) Create and run your generator-angularjs-cordova project ###

1. run `vagrant ssh`
2. run `cd /vagrant`
3. run `cordova create folder-name -n ProjectName`
4. run `cd folder-name`
5. run `yo angularjs-cordova`
6. run `sed -i -e s/localhost/0.0.0.0/' Gruntfile.js`
To host a development web server:
7. run `grunt serve`
To emulate on device:
8. run `cordova build`
9. run `cordova emulate android`

## About ##

This box will install and configure the following:

* Vim
* Git
* Node.js
* Npm
* Java SDK
* Android SDK
* Ant
* grunt-cli
* bower
* yo
* cordova
* chromium
* webstorm and sublime
