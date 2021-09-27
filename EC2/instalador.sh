#!/bin/bash
sudo adduser stephanie
echo mudar@123 | sudo passwd --stdin stephanie #Não recomendado o uso de senhas fracas, adicionado apenas como exemplo
echo mudar@123 | sudo passwd --stdin root #Não recomendado o uso de senhas fracas, adicionado apenas como exemplo
sudo amazon-linux-extras install nginx1 #Padrão de instalação Amazon Linux, verificar o padrão que vc irá utilizar e atualizar
sudo systemctl enable nginx.service
sudo systemctl start nginx.service
sudo echo "<p> Funciona! Stephanie Tavares</p>" >> /usr/share/nginx/html/index.html
