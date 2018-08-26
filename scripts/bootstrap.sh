#!/bin/sh
set +x

# Maven
echo "Maven setup..."
bash /maven.sh
echo "... done."

## Works!
mvn -Dhttps.protocols=TLSv1.2 \
  -Dmaven.buildNumber.doCheck=false \
  -Dmaven.buildNumber.doUpdate=false \
  clean package war:war

# Move completed binary
cp /app/target/ZY.war /opt/tomcat/webapps/
