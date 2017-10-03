#!/bin/sh

AM_TOOLS_HOME="/usr/lib/archivematica/automation-tools"
AM_TOOLS_CONF="/etc/archivematica/automation-tools"

AM_SHARED_DIR="/var/archivematica/sharedDirectory"
AM_PROCESSING_CONF_DIR="${AM_SHARED_DIR}/sharedMicroServiceTasksConfigs/processingMCPConfigs"
AM_PROCESSING_CONF_FILE="${AM_TOOLS_TRANSFER_PROCESSING_XML:-automatedProcessingMCP.xml}"

# Create environment
pip install -r "${AM_TOOLS_HOME}/requirements/base.txt"
mkdir -p "${AM_TOOLS_CONF}"
cp "${AM_TOOLS_HOME}/etc/transfers.conf" "${AM_TOOLS_CONF}/"
cp "${AM_TOOLS_HOME}/etc/transfer-script.sh" "${AM_TOOLS_CONF}/"

# Set up logging
mkdir -p "/var/log/archivematica/automation-tools"
mkdir -p "/var/archivematica/automation-tools"

# Link to the given Processing XML in our transfer config directory
ln -s "${AM_PROCESSING_CONF_DIR}/${AM_PROCESSING_CONF_FILE}" \
    "${AM_TOOLS_HOME}/transfers/pre-transfer/"

# Copy and modify the python script that will load the processing XML into our transfer context
cp "${AM_TOOLS_HOME}/transfers/examples/pre-transfer/default_config.py" \
    "${AM_TOOLS_HOME}/transfers/pre-transfer/mcp_config.py"
sed -i "s/defaultProcessingMCP.xml/${AM_PROCESSING_CONF_FILE}/" \
    "${AM_TOOLS_HOME}/transfers/pre-transfer/mcp_config.py"
