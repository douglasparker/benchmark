#!/bin/bash

cleanup () {
    # Uninstall Ookla Speedtest
    sudo apt-get purge speedtest > /dev/null
    sudo rm /etc/apt/sources.list.d/speedtest.list
    sudo apt-get update > /dev/null

    # Uninstall Geekbench
    rm -r /opt/geekbench
}

trap cleanup EXIT

# Install Ookla Speedtest
# See more: https://www.speedtest.net
sudo apt-get install gnupg1 apt-transport-https dirmngr
export INSTALL_KEY=379CE192D401AB61
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $INSTALL_KEY
echo "deb https://ookla.bintray.com/debian generic main" | sudo tee /etc/apt/sources.list.d/speedtest.list
sudo apt-get update
sudo apt-get install speedtest

# Install Geekbench
# See more: https://www.geekbench.com
mkdir -p /opt/geekbench
curl -L https://cdn.geekbench.com/Geekbench-5.3.1-Linux.tar.gz --output /opt/geekbench/geekbench.tar.gz
tar -xf /opt/geekbench/geekbench.tar.gz -C /opt/geekbench
mv /opt/geekbench/Geekbench-*-Linux/* /opt/geekbench
rm -r /opt/geekbench/Geekbench-*-Linux
rm /opt/geekbench/geekbench.tar.gz

# Run Ookla Speedtest
speedtest

# Run Geekbench
ARCHITECTURE=$(uname -m)
if [ $ARCHITECTURE == "x86_64" ]; then
    /opt/geekbench/geekbench_x86_64
else
    /opt/geekbench/geekbench5
fi