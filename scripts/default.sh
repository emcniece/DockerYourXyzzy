#!/bin/bash
set -e

mvn jetty:run -Dhttps.protocols=TLSv1.2 -Dmaven.buildNumber.doCheck=false -Dmaven.buildNumber.doUpdate=false "$@"