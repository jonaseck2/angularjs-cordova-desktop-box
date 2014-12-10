sudo apt-get update
sudo apt-get -qqy install docker.io
sudo apt-get update && sudo apt-get install cgroup-lite apparmor
sudo apt-get update
sudo apt-get install apt-transport-https
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
sudo apt-get update
sudo apt-get -qqy install lxc-docker
sudo reboot