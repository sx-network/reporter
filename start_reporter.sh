#!/bin/bash

EC2_PUBLIC_IP=$1

# Update systemd service
cd /etc/systemd/system
echo "[Unit]
Description=SX Reporter Service
After=network.target
[Service]
Type=simple
Restart=always
RestartSec=1
User=$USER
LimitNOFILE=100000
WorkingDirectory=/home/$USER/reporter/sx-reporter-node
ExecStart=/home/$USER/reporter/sx-reporter-node/main server --config config.yml
[Install]
WantedBy=multi-user.target" | sudo tee sx-reporter.service
if grep -q ForwardToSyslog=yes "/etc/systemd/journald.conf"; then
  sudo sed -i '/#ForwardToSyslog=yes/c\ForwardToSyslog=no' /etc/systemd/journald.conf
  sudo sed -i '/ForwardToSyslog=yes/c\ForwardToSyslog=no' /etc/systemd/journald.conf
elif ! grep -q ForwardToSyslog=no "/etc/systemd/journald.conf"; then
  echo "ForwardToSyslog=no" | sudo tee -a /etc/systemd/journald.conf
fi
cd -
echo

# Update config
cd /home/$USER/reporter/sx-reporter-node
echo "data_dir: /home/$USER/reporter/sx-reporter-node/data
log_level: DEBUG
reporter:
  verify_outcome_api_url: https://outcome-reporter.sx.technology/api/outcome
  sx_node_address: 0xb2EA86f774CC455bb3BD1Cea73851BF3D2467778
  outcome_reporter_address: 0x041670fF3FfdA1Da64BF54b5aE009eda19BaB8a3" | sudo tee config.yml

# Start systemd Service
echo "Starting sx-reporter-node service..."
sudo systemctl force-reload systemd-journald
sudo systemctl daemon-reload
sudo systemctl start sx-reporter.service

read -n 1 -s -r -p "Service successfully started! Press any key to continue..."
echo