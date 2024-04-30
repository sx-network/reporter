#!/bin/bash

EC2_PUBLIC_IP=$1

# Update systemd service
cd /etc/systemd/system
echo "[Unit]
Description=SX Reporter Node Service
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
sudo systemctl daemon-reload

# Update config
cd /home/$USER/reporter/sx-reporter-node
echo "data_dir: /home/$USER/reporter/sx-reporter-node/data
log_level: DEBUG
reporter:
  verify_outcome_api_url: https://outcome-reporter.sx.technology/api/outcome
  sx_node_address: 0xb2EA86f774CC455bb3BD1Cea73851BF3D2467778
  outcome_reporter_address: 0x041670fF3FfdA1Da64BF54b5aE009eda19BaB8a3" | sudo tee config.yml

# Update binary
echo "Updating sx-reporter-node service..."
git pull
sudo systemctl stop sx-reporter.service
make build
sudo systemctl restart sx-reporter.service

read -n 1 -s -r -p "Service successfully updated! Press any key to continue..."
echo