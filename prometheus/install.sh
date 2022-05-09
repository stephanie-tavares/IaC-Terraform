#!/bin/bash

#======INSTALL PROMETHEUS======#

sudo useradd -M -r -s /bin/false prometheus
sudo mkdir /etc/prometheus /var/lib/prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.20.0/prometheus-2.20.0.linux-amd64.tar.gz
tar xzf prometheus-2.20.0.linux-amd64.tar.gz prometheus-2.20.0.linux-amd64/


sudo cp prometheus-2.20.0.linux-amd64/{prometheus,promtool} /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/{prometheus,promtool}
sudo cp -r prometheus-2.20.0.linux-amd64/{consoles,console_libraries} /etc/prometheus/
sudo cp prometheus-2.20.0.linux-amd64/prometheus.yml /etc/prometheus/prometheus.yml
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus
sudo echo "
[Unit]
Description=Prometheus Time Series Collection and Processing Server
Wants=network-online.target
After=network-online.target
[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \\
    --config.file /etc/prometheus/prometheus.yml \\
    --storage.tsdb.path /var/lib/prometheus/ \\
    --web.console.templates=/etc/prometheus/consoles \\
    --web.console.libraries=/etc/prometheus/console_libraries
[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/prometheus.service

sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

#====== INSTALANDO O GRAFANA ======#

sudo echo " 
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
" | sudo tee /etc/yum.repos.d/grafana.repo

sudo yum install -y grafana
sudo systemctl enable --now grafana-server
