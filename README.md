Docker Image for Archivematica Automation Tools
================================================

This repository provides a Docker image for the [Archivematica Automation Tools](https://github.com/artefactual/automation-tools). The image includes scripts to set up and configure the Automation Tools, as well as to monitor for new transfer input and kick off its processing. Environment variables are used to pass in parameters to the transfer process. It is based on the official [python:2-alpine](https://hub.docker.com/_/python/) image.

Build
------

The image build uses Make:

	make

The build can be customised using build variables, see below.

### Build Variables

| Variable | Description | Default |
|---|---|---|
| IMAGE_TAG_NAME | The name to tag the image with. | `arkivum/archivematica-automation-tools` |
| IMAGE_TAG_VERSION | The version to "tag" the image with. | `latest` |

For example, to override the tag name and version

	make IMAGE_TAG_NAME=am-auto-tools IMAGE_TAG_VERSION=1.0

Environment Variables
----------------------

| Variable | Description | Default |
|---|---|---|
| `AM_TOOLS_TRANSFER_AM_API_KEY` | The API key to use when connecting to the Archivematica Dashboard. | None |
| `AM_TOOLS_TRANSFER_AM_URL` | The URL to use when connecting to the Archivematica Dashboard. | `http://127.0.0.1` |
| `AM_TOOLS_TRANSFER_AM_USER` | The username to use when connecting to the Archivematica Dashboard. | None |
| `AM_TOOLS_TRANSFER_DEPTH` | The "depth" to use for the transfer, as documented in the Automation Tools README. | `1` |
| `AM_TOOLS_TRANSFER_PATH` | The path to use for the transfer, as documented in the Automation Tools README. | `''` |
| `AM_TOOLS_TRANSFER_SOURCE_DESCRIPTION` | The "description" of the transfer source defined in the Archivematica Storage Service to use as the source for automated transfers. Case sensitive. | None |
| `AM_TOOLS_TRANSFER_SS_API_KEY` | The API key to use when connecting to the Archivematica Storage Service. | None |
| `AM_TOOLS_TRANSFER_SS_URL` | The URL to use when connecting to the Archivematica Storage Service. | `http://127.0.0.1:8000` |
| `AM_TOOLS_TRANSFER_SS_USER` | The username to use when connecting to the Archivematica Storage Service. | None |
| `AM_TOOLS_TRANSFER_TYPE` | The "type" to use for the transfer, as documented in the Automation Tools README. | `standard` |

Operation
----------

Aside from the Automation Tools themselves, the image consists of three scripts:

* [run.sh](rootfs/usr/local/bin/run.sh), which acts as the entry point for the image
* [setup.sh](rootfs/usr/local/bin/setup.sh), which does initial configuration
* [transfer.sh](rootfs/usr/local/bin/transfer.sh). which is run periodically to do the actual transfer processing.

The run script triggers the setup script if no configuration is found, and runs the transfer script periodically once setup has been done.

The setup script configures the Automation Tools installation, installing required Python modules and copying configuration files from the Automation Tools distribution and the `sharedDirectory` used by all Archivematica Components.

The transfer script uses the `transfers.transfer` module included in the Automation Tools [as documented in the README](https://github.com/artefactual/automation-tools/blob/master/README.md#automated-transfers). The parameters it passes use values from the environment variables specified above.

The `transfer` module expects a UUID to be specified to identify the transfer source location to transfer data from. However, there is no way to know this since the UUIDs used by the Archivematica Storage Service to identify the location is randomly generated. In order to "discover" it, we therefore need to use some other means to identify the desired transfer source location.

The `description` of the transfer source location is considered to be almost unique, since it is highly unlikely that two locations are going to have the same description. We can therefore use this to filter the list of storage locations, which we can get from the Storage Service API. The `AM_TOOLS_TRANSFER_SOURCE_DESCRIPTION` environment variable is used to specify the value that should be matched, in a case-sensitive manner. This means that the source description value **must** match exactly the value input into the Storage Service.

If a transfer source location is not found with the given description then transfer script will exit and no transfers will be processed.

Docker Compose
---------------

Here's an example of how this image can be used in a Docker Compose configuration:

	---
	version: "2"

	volumes:
	  archivematica_pipeline_data:

	services:

	  archivematica-automation-tools:
	    build: '../src/rdss-archivematica-automation-tools/'
	    environment:
	      AM_TOOLS_TRANSFER_AM_API_KEY: "test"
	      AM_TOOLS_TRANSFER_AM_URL: "http://archivematica"
	      AM_TOOLS_TRANSFER_AM_USER: "test"
	      AM_TOOLS_TRANSFER_SOURCE_DESCRIPTION: "automated workflow"
	      AM_TOOLS_TRANSFER_SS_API_KEY: "test"
	      AM_TOOLS_TRANSFER_SS_URL: "http://archivematica-storage-service:8000"
	      AM_TOOLS_TRANSFER_SS_USER: "test"
	    volumes:
	      - "archivematica_pipeline_data:/var/archivematica/sharedDirectory"
	    links:
	      - "archivematica-dashboard"
	      - "archivematica-storage-service"

Note that this service is intended to deployed along with the main Archivematica services, and in this example has `links` to the `archivematica-dashboard` and `archivematica-storage-service` servuces. It does not make sense to deploy the Automation Tools in isolation: it depends on the core Archivematica components, however the definition of these services is beyond the scope of this project. An [archetypal example](https://github.com/JiscRDSS/rdss-archivematica/blob/master/compose/docker-compose.dev.yml) is available as part of the [rdss-archivematica](https://github.com/JiscRDSS/rdss-archivematica/) repository.
