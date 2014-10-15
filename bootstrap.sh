#!/usr/bin/env bash

# constants
gradle_version=1.12
webstorm_version=8.0.5
webstorm_icon_name="Webstorm.desktop"

# Url
webstorm_url="http://download.jetbrains.com/webstorm/WebStorm-${webstorm_version}.tar.gz"
gradle_url="https://services.gradle.org/distributions/gradle-${gradle_version}-all.zip"

# Path
program_path="/home/vagrant/program"
download_path="/vagrant/.download" 
webstorm_icon_name_path="/home/vagrant/Desktop/$webstorm_icon_name"

# Help functions

function file_download()
{
        wget $1 --no-verbose -N -P "$download_path"
        dest_path="$program_path"/$2
        mkdir -p "$dest_path"

        case "$3" in
                untar)
                /bin/tar xzf "$download_path/$(basename "$1")" -C "$dest_path"
                ;;

                unzip)
                /usr/bin/unzip "$download_path/$(basename "$1")" -d "$dest_path"
                ;;

                *)
                echo  "$3 not supported"
        esac

}

function install_gradle() {
        mkdir /opt/gradle
        wget -N $gradle_url -P "$download_path" 
        unzip -oq $download_path/gradle-${gradle_version}-all.zip -d /opt/gradle
        ln -sfnv /opt/gradle/gradle-${gradle_version} /opt/gradle/latest
        printf "export GRADLE_HOME=/opt/gradle/latest\nexport PATH=\$PATH:\$GRADLE_HOME/bin" > /etc/profile.d/gradle.sh
        . /etc/profile.d/gradle.sh
        chmod +x /etc/profile.d/gradle.sh
}

# Main program

# Install java8
add-apt-repository -y ppa:webupd8team/java 
apt-get -y update
echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
apt-get -qq -y install oracle-java8-installer oracle-java8-set-default

# Install WebStorm
file_download "${webstorm_url}" "webstorm" "untar"

# Web storm desktop icon
temp=$(/usr/bin/find $program_path -iname webstorm.sh)
webstorm_install_path=$(dirname "$temp")
echo "[Desktop Entry]" > $webstorm_icon_name_path
echo "Type=Application" >> $webstorm_icon_name_path
echo "Name=Webstorm" >> $webstorm_icon_name_path
echo "Icon=$webstorm_install_path/webide.png" >> $webstorm_icon_name_path
echo "Exec=$webstorm_install_path/webstorm.sh" >> $webstorm_icon_name_path
echo "Path=$webstorm_install_path" >> $webstorm_icon_name_path
echo "Terminal=false" >> $webstorm_icon_name_path

#Install gradle
install_gradle

#Install eclipse
sudo apt-get -qq -y install eclipse

#Install eclipse gradle plugin
eclipse -nosplash -application org.eclipse.equinox.p2.director -repository http://dist.springsource.com/release/TOOLS/gradle -installIU org.springsource.ide.eclipse.gradle.feature.feature.group

#Install python with PIP and VirtualEnv
sudo apt-get -qq -y install python-pip python-virtualenv

#Install chrome
sudo apt-get -qq -y install chromium-browser
