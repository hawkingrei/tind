#!/bin/sh
set -eu

. /etc/os-release

apt-get update
apt-get install -y gnupg software-properties-common
add-apt-repository -y ppa:deadsnakes/ppa

apt-get update
apt-get install -y \
    libmemcached-dev \
    python3-pip \
    python3-distutils \
    python3-setuptools \
    \
    python2.? \
    python2.?-dev \
    python3.? \
    python3.?-dev \
    python3.?-venv \ 
    supervisor 

pip3 install \
    flit \
    tox \
    virtualenv \
    mycli \
    ;

apt-get --purge autoremove -y gnupg
rm -rf /var/cache/apt/lists

dpkg-query --show python2.? python3.? > /versions
