#!/bin/bash
set -e
echo "Using build.properties overrides"
# Copies overides
cat build.properties.example /overrides/build.properties > build.properties  2>/dev/null || cp build.properties.example build.properties
# Builds
mvn clean package war:exploded -Dhttps.protocols=TLSv1.2 -Dmaven.buildNumber.doCheck=false -Dmaven.buildNumber.doUpdate=false 
# Runs
mvn jetty:run -Dhttps.protocols=TLSv1.2 -Dmaven.buildNumber.doCheck=false -Dmaven.buildNumber.doUpdate=false