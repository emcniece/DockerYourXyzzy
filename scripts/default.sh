#!/bin/bash

if [[ ! -f "build.properties" ]]; then
    mv build.properties.example build.properties
fi

mvn clean package war:exploded jetty:run -Dhttps.protocols=TLSv1.2 -Dmaven.buildNumber.doCheck=false -Dmaven.buildNumber.doUpdate=false "$@"
