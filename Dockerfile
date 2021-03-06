FROM ubuntu:14.10

RUN apt-get -y update

RUN apt-get -y upgrade

# Install Java 8
RUN apt-get -y install wget openjdk-8-jdk

# Install remote_syslog2
RUN wget https://github.com/papertrail/remote_syslog2/releases/download/v0.13/remote_syslog_linux_amd64.tar.gz
RUN tar zxvf remote_syslog_linux_amd64.tar.gz -C /opt/

# Download, build and install geoipupdate together with our licence key and config for it.
# This pulls in a tonne of dev/build dependencies.
# Sadly there's no binary package for this, geoipupdate from the geoip-bin package on Ubuntu only
# supports the legacy maxmind format, not GeoIP2 databases.
# TODO we could create our own pre-built binaries of geoipupdate to circumvent some of this
# nonsense.
RUN wget https://github.com/maxmind/geoipupdate/releases/download/v2.0.2/geoipupdate-2.0.2.tar.gz
RUN apt-get install -y build-essential libcurl4-openssl-dev zlib1g-dev
RUN tar zxvf geoipupdate-2.0.2.tar.gz
RUN cd geoipupdate-2.0.2 && ./configure && make && make install
RUN mkdir /usr/local/share/GeoIP
RUN ln -s /usr/local/bin/geoipupdate /etc/cron.daily/geoipupdate

# Now do 'ADD GeoIP.conf /usr/local/etc/GeoIP.conf' in derived container
