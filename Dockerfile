FROM davidcaste/alpine-tomcat:jdk8tomcat7 as base

# MAVEN
ARG MAVEN_VERSION=3.5.4
ARG USER_HOME_DIR="/root"
ARG SHA=ce50b1c91364cb77efe3776f756a6d92b76d9038b0a0782f7d53acf1e997a14d
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

RUN apk add --no-cache curl tar bash procps \
 && mkdir -p /usr/share/maven /usr/share/maven/ref \
 && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
 && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha256sum -c - \
 && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
 && rm -f /tmp/apache-maven.tar.gz \
 && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ADD ./overrides/settings-docker.xml /usr/share/maven/ref/
ADD overrides /overrides
ADD scripts/entrypoint.sh scripts/bootstrap.sh scripts/maven.sh /

# PYX
ENV GIT_BRANCH="master"
VOLUME /app /output

RUN apk --no-cache add git openssh \
 && git clone -b $GIT_BRANCH https://github.com/ajanata/PretendYoureXyzzy.git /project \
 && cd project \
 && cp build.properties.example build.properties \
 && mvn clean package war:war -Dhttps.protocols=TLSv1.2 -Dmaven.buildNumber.doCheck=false -Dmaven.buildNumber.doUpdate=false

# ---
# docker build --target base .
ENTRYPOINT ["/entrypoint.sh"]
CMD cp /project/target/ZY.war /output && cp /project/target/ZY.jar /output

# ---
# docker build --target dev .
FROM base AS dev
WORKDIR /app
CMD mvn clean package war:exploded jetty:run -Dhttps.protocols=TLSv1.2 -Dmaven.buildNumber.doCheck=false -Dmaven.buildNumber.doUpdate=false

# ---
# docker build .
# or:
# docker build --target runtime .
FROM davidcaste/alpine-tomcat:jre8tomcat7 AS run
COPY --from=base /project/target/ZY.war /opt/tomcat/webapps/
VOLUME /opt/tomcat/webapps/
CMD /opt/tomcat/bin/catalina.sh run
