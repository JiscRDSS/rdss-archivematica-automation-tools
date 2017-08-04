#!/bin/sh

AM_TOOLS_HOME="/usr/lib/archivematica/automation-tools"

if [ ! -f "${AM_TOOLS_HOME}/transfers/pre-transfer/default_config.py"  ] ; then
    setup.sh
fi

# Run transfer script every two minutes
while true; do
    transfer.sh
    sleep 120
done
