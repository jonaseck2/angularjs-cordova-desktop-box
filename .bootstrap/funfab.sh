#!/usr/bin/env bash

# constants
gradle_version=1.12
webstorm_version=8.0.5
webstorm_icon_name="Webstorm.desktop"

# Url
webstorm_url="http://download.jetbrains.com/webstorm/WebStorm-${webstorm_version}.tar.gz"
gradle_url="https://services.gradle.org/distributions/gradle-${gradle_version}-all.zip"
eclipse_url="http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/luna/SR1-RC3/eclipse-java-luna-SR1-RC3-linux-gtk-x86_64.tar.gz"

# Path
download_path="/vagrant/.download" 
webstorm_icon_name_path="/home/vagrant/Desktop/$webstorm_icon_name"

# Help functions

function file_download()
{
        if [ ! -f ${download_path}/${1##*/} ] ; then
                echo "Downloading $1"
                mkdir -vp "${download_path}"
                wget -O "${download_path}/${1##*/}" $1 --quiet
        fi

        if [ ! -d ${2} ] ; then
                echo "Unpacking ${1##*/} to $2"
                mkdir -vp "${2}"

                case "${1##*.}" in
                        gz)
                        if [ "${1##*.tar.}" == "gz" ] ; then
                                tar xzf "$download_path/${1##*/}" -C "$2"
                        else
                                gunzip -q -c "$download_path/${1##*/}" > "$2"
                        fi
                        ;;
                        zip)
                        unzip -qq "$download_path/${1##*/}" -d "$2"
                esac
        fi
}

# Main program

# Enable autologin

if [ -f "/etc/lightdm/lightdm.conf.d/20-lubuntu.conf" && `grep vagrant /etc/lightdm/lightdm.conf.d/20-lubuntu.conf | wc -l` -le 0 ]; then
   echo autologin-user=vagrant >> /etc/lightdm/lightdm.conf.d/20-lubuntu.conf
   echo autologin-user-timeout=0 >> /etc/lightdm/lightdm.conf.d/20-lubuntu.conf
   echo greeter-session=lightdm-gtk-greeter >> /etc/lightdm/lightdm.conf.d/20-lubuntu.conf
fi

# Set timezone to Europe/Stockholm
sudo bash -c 'echo "Europe/Stockholm" > /etc/timezone'

# Install java8
add-apt-repository -y ppa:webupd8team/java 
apt-get -qqy update
echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
apt-get -qqy install oracle-java8-installer oracle-java8-set-default 2> /dev/null

# Install WebStorm
if [ ! -d "/usr/local/lib/webstorm" ]; then
   file_download "${webstorm_url}" "/usr/local/lib/webstorm"
   ln -sfnv /usr/local/lib/webstorm/WebStorm-135.1297 /usr/local/lib/webstorm/latest
   ln -sfnv /usr/local/lib/webstorm/latest/bin/webstorm.sh /usr/local/bin/webstorm

# Web storm desktop icon
   echo "[Desktop Entry]" > $webstorm_icon_name_path
   echo "Type=Application" >> $webstorm_icon_name_path
   echo "Name=Webstorm" >> $webstorm_icon_name_path
   echo "Icon=/usr/local/lib/webstorm/latest/bin/webide.png" >> $webstorm_icon_name_path
   echo "Exec=/usr/local/lib/webstorm/latest/bin/webstorm.sh" >> $webstorm_icon_name_path
   echo "Path=/usr/local/lib/webstorm/latest/bin/" >> $webstorm_icon_name_path
   echo "Terminal=false" >> $webstorm_icon_name_path
fi 

#Install gradle
if [ ! -f "/usr/local/lib/gradle" ]; then
   file_download "${gradle_url}" "/usr/local/lib/gradle"
   ln -sfnv /usr/local/lib/gradle/gradle-${gradle_version} /usr/local/lib/gradle/latest
   ln -sfnv /usr/local/lib/gradle/latest/bin/gradle /usr/local/bin/gradle
fi

#Install eclipse
file_download "${eclipse_url}" "/usr/local/lib/eclipse"
# wget --quiet -O eclipse.tar.gz "http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/luna/SR1-RC3/eclipse-java-luna-SR1-RC3-linux-gtk-x86_64.tar.gz"
# tar -zxvf eclipse.tar.gz
# sudo mv eclipse /opt
#sudo ln -s /opt/eclipse/eclipse /usr/bin/eclipse
echo "eclipse downloaded and unzipped"
sudo ln -s /usr/local/lib/eclipse/eclipse/eclipse /usr/bin/eclipse
sudo touch /usr/share/applications/eclipse.desktop
sudo sh -c "echo '[Desktop Entry]
  Version=1.0
  Name=Eclipse
  
  Exec=eclipse
  Terminal=false
  Icon=/opt/eclipse/icon.xpm
  Type=Application
  Categories=IDE;Development
  X-Ayatana-Desktop-Shortcuts=NewWindow

[NewWindow Shortcut Group]
  Name=New Window
  Exec=eclipse
  TargetEnvironment=Unity' > /usr/share/applications/eclipse.desktop"

#Install eclipse gradle plugin
eclipse -nosplash -application org.eclipse.equinox.p2.director -repository http://dist.springsource.com/release/TOOLS/gradle -installIU org.springsource.ide.eclipse.gradle.feature.feature.group

#Install python with PIP and VirtualEnv
apt-get -qqy install python-pip python-virtualenv

#Install chrome
apt-get -qqy install chromium-browser

#Install git and vim
apt-get -qqy install git vim
git config --system core.editor vi
