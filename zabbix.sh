#!/bin/bash

# Prompt the user for Zabbix server IP address and agent hostname
read -p "Please enter the Zabbix server IP address: " ZABBIX_SERVER_IP
read -p "Please enter the hostname for the monitored Linux host: " AGENT_HOSTNAME

# Install prerequisites and update the system
echo "Updating system and installing prerequisites..."
sudo apt update
sudo apt install -y wget gnupg

# Add Zabbix repository and update package lists
echo "Adding Zabbix repository..."
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.0-1+ubuntu22.04_all.deb -O zabbix-release.deb
sudo dpkg -i zabbix-release.deb
sudo apt update

# Attempt to fix broken dependencies
echo "Fixing any broken dependencies..."
sudo apt --fix-broken install -y

# Install Zabbix Agent2 and plugins
echo "Installing Zabbix Agent2 and plugins..."
if sudo apt install -y zabbix-agent2 zabbix-agent2-plugin-*; then
    echo "Zabbix Agent2 installed successfully."
else
    echo "Failed to install Zabbix Agent2 due to dependency issues. Exiting."
    exit 1
fi

# Configure Zabbix Agent2
AGENT_CONF="/etc/zabbix/zabbix_agent2.conf"
if [[ -f "$AGENT_CONF" ]]; then
    echo "Configuring Zabbix Agent2..."
    sudo sed -i "s/^Server=.*/Server=${ZABBIX_SERVER_IP}/" $AGENT_CONF
    sudo sed -i "s/^ServerActive=.*/ServerActive=${ZABBIX_SERVER_IP}/" $AGENT_CONF
    sudo sed -i "s/^Hostname=.*/Hostname=${AGENT_HOSTNAME}/" $AGENT_CONF

    # Restart and enable Zabbix Agent2 service
    echo "Restarting and enabling Zabbix Agent2 service..."
    sudo systemctl restart zabbix-agent2
    sudo systemctl enable zabbix-agent2
else
    echo "Configuration file $AGENT_CONF not found. Exiting."
    exit 1
fi

# Configure firewall (allow port 10050 for Zabbix Agent communication)
echo "Configuring firewall..."
sudo ufw allow 10050/tcp

# Clean up downloaded package
rm zabbix-release.deb

# Display completion message with the configured settings
echo "Zabbix Agent2 installation and configuration completed with the following settings:"
echo "Zabbix Server IP: $ZABBIX_SERVER_IP"
echo "Agent Hostname: $AGENT_HOSTNAME"
