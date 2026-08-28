#!/bin/bash
sudo adduser stephanie
echo mudar@123 | sudo passwd --stdin stephanie 
echo mudar@123 | sudo passwd --stdin root 
sudo amazon-linux-extras install nginx1 
sudo systemctl enable nginx.service
sudo systemctl start nginx.service
sudo echo "<p> Funciona! Stephanie Tavares</p>" >> /usr/share/nginx/html/index.html
