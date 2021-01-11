#!/bin/bash
set -e

# Command exec
mvn jetty:run -Dhttps.protocols=TLSv1.2 -Dmaven.buildNumber.doCheck=false -Dmaven.buildNumber.doUpdate=false