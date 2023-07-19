#!/bin/bash
sudo apt-get update
sudo apt install curl -y
sudo apt install nginx -y 
sudo apt install git -y
git clone https://github.com/cloudacademy/static-website-example.git
mv static-website-example/* /var/www/html/