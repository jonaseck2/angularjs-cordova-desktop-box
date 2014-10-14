#!/usr/bin/env bash

webstorm_url="http://download.jetbrains.com/webstorm/WebStorm-8.0.4.tar.gz"
gradle_url="https://services.gradle.org/distributions/gradle-1.12-bin.zip"
program_path="/home/vagrant/program"
download_path="/vagrant/.download"
temp_path="~/temp"
test="ftp://ftp.sunet.se/pub/www/utilities/curl/curl-7.38.0.tar.gz"

# constants
gradle_version=1.12

# Help functions

function file_download()
{
        wget $1 -N -P "$download_path"
        dest_path="$program_path"/$2
        mkdir -p "$dest_path"

        case "$3" in
                untar)
                /bin/tar xzf "$download_path/$(basename "$1")" -C "$dest_path"
                ;;

                unzip)
                /usr/bin/unzip "$download_path/$(basename "$1")"  -d "$dest_path"
                ;;

                *)
                echo  "$3 not supported"
        esac

}

function install_gradle() {
        mkdir /opt/gradle
        wget -N http://services.gradle.org/distributions/gradle-${gradle_version}-all.zip -P "$download_path" 
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
file_download "${webstorm_url}" "webstorm"

#Install gradle
#file_download "${gradle_url}" "gradle"
#echo 'export PATH=${PATH}:"${program_path}/gradle"' >> ${HOME}/.bash_profile

#Install eclipse
sudo apt-get install eclipse

#Install eclipse gradle plugin
eclipse -nosplash -application org.eclipse.equinox.p2.director -repository http://dist.springsource.com/release/TOOLS/gradle -installIU org.springsource.ide.eclipse.gradle.feature.feature.group

#Install python with PIP and VirtualEnv
sudo apt-get install python-pip python-virtualenv

#Install chrome
sudo apt-get install chromium-browser
