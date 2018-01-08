#!/bin/sh

# See https://github.com/artefactual/automation-tools/blob/master/README.md

SS_URL="${AM_TOOLS_TRANSFER_SS_URL:-http://127.0.0.1:8000}"

#
# Use the Storage Service API to discover what the UUID is for the requested
# transfer source, based on its description.
#
# Here we use `curl` to get a list of all storage locations, then use `jq` to
# filter this list to just those that have the "purpose" of "TS" (transfer
# source) and a "description" that matches that given in the environment
# variable. Assuming we get one that does, we then select just the "uuid",
# thereby giving us our selected transfer source id.
#
transfer_source_id=$(curl -k -s \
    -H "Authorization: ApiKey ${AM_TOOLS_TRANSFER_SS_USER}:${AM_TOOLS_TRANSFER_SS_API_KEY}" \
        "${SS_URL}/api/v2/location/" | \
    jq -r ".objects[] | select(.purpose == \"TS\" and .description == \"${AM_TOOLS_TRANSFER_SOURCE_DESCRIPTION}\") | .uuid")

if [ "${transfer_source_id}" = "" ] ; then
    >&2 echo "No transfer source found matching description '${AM_TOOLS_TRANSFER_SOURCE_DESCRIPTION}'"
    exit 1
fi
echo "Using transfer source id '${transfer_source_id}'"

# Found the transfer source, do the transfer
cd /usr/lib/archivematica/automation-tools/ && \
python -m transfers.transfer \
  --am-url "${AM_TOOLS_TRANSFER_AM_URL:-http://127.0.0.1}" \
  --api-key "${AM_TOOLS_TRANSFER_AM_API_KEY}" \
  --config-file "/etc/archivematica/automation-tools/transfers.conf" \
  --depth "${AM_TOOLS_TRANSFER_DEPTH:-1}" \
  --log-level "${AM_TOOLS_TRANSFER_LOG_LEVEL:-INFO}" \
  --ss-api-key "${AM_TOOLS_TRANSFER_SS_API_KEY}" \
  --ss-url "${SS_URL}" \
  --ss-user "${AM_TOOLS_TRANSFER_SS_USER}" \
  --transfer-path "${AM_TOOLS_TRANSFER_PATH}" \
  --transfer-source "${transfer_source_id}" \
  --transfer-type "${AM_TOOLS_TRANSFER_TYPE:-standard}" \
  --verbose \
  --user "${AM_TOOLS_TRANSFER_AM_USER}"
