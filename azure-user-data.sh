#!/bin/bash
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo apt-get install openjdk-11-jre -y
sudo apt install jenkins -y
sudo usermod -aG docker jenkins
echo "jenkins ALL= (ALL) NOPASSWD: ALL" >> /etc/sudoers
sudo systemctl enable docker --now
sudo systemctl enable jenkins --now
sudo cat /var/lib/jenkins/secrets/initialAdminPassword