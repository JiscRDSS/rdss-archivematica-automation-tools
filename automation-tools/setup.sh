#!/bin/sh

# Create environment
pip install -r /usr/lib/archivematica/automation-tools/requirements/base.txt
mkdir -p /etc/archivematica/automation-tools
cp /usr/lib/archivematica/automation-tools/etc/transfers.conf /etc/archivematica/automation-tools
cp /usr/lib/archivematica/automation-tools/etc/transfer-script.sh /etc/archivematica/automation-tools

# Set up logging
mkdir -p /var/log/archivematica/automation-tools
mkdir -p /var/archivematica/automation-tools

# Set up XML config files to define behaviour
cp /var/archivematica/sharedDirectory/sharedMicroServiceTasksConfigs/processingMCPConfigs/defaultProcessingMCP.xml /usr/lib/archivematica/automation-tools/transfers/pre-transfer/
cp /usr/lib/archivematica/automation-tools/transfers/examples/pre-transfer/default_config.py /usr/lib/archivematica/automation-tools/transfers/pre-transfer/

# Set up transfer script
chmod +x /etc/archivematica/automation-tools/transfer-script.sh

# Run transfer script every two minutes
while true; do
    sh /etc/archivematica/automation-tools/transfer-script.sh;
    sleep 120
done

