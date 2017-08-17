#!/bin/sh

AM_TOOLS_HOME="/usr/lib/archivematica/automation-tools"
AM_TOOLS_CONF="/etc/archivematica/automation-tools"

AM_SHARED_DIR="/var/archivematica/sharedDirectory"
AM_PROCESSING_CONF="${AM_SHARED_DIR}/sharedMicroServiceTasksConfigs/processingMCPConfigs"

# Create environment
pip install -r "${AM_TOOLS_HOME}/requirements/base.txt"
mkdir -p "${AM_TOOLS_CONF}"
cp "${AM_TOOLS_HOME}/etc/transfers.conf" "${AM_TOOLS_CONF}/"
cp "${AM_TOOLS_HOME}/etc/transfer-script.sh" "${AM_TOOLS_CONF}/"

# Set up logging
mkdir -p "/var/log/archivematica/automation-tools"
mkdir -p "/var/archivematica/automation-tools"

# Set up XML config files to define behaviour
cp "${AM_PROCESSING_CONF}/defaultProcessingMCP.xml" \
    "${AM_TOOLS_HOME}/transfers/pre-transfer/"
chmod -x "${AM_TOOLS_HOME}/transfers/pre-transfer/defaultProcessingMCP.xml"
cp "${AM_TOOLS_HOME}/transfers/examples/pre-transfer/default_config.py" \
    "${AM_TOOLS_HOME}/transfers/pre-transfer/"
