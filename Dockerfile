FROM davidcaste/alpine-tomcat:jdk8tomcat7

# MAVEN
ENV MAVEN_VERSION 3.5.4
ENV USER_HOME_DIR /root
ENV SHA ce50b1c91364cb77efe3776f756a6d92b76d9038b0a0782f7d53acf1e997a14d
ENV BASE_URL https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

RUN apk add --no-cache curl tar procps \
 && mkdir -p /usr/share/maven/ref \
 && curl -fsSL -o /tmp/apache-maven.tar.gz "${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
 && echo "${SHA} /tmp/apache-maven.tar.gz" | sha256sum -c - || true \
 && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
 && rm -f /tmp/apache-maven.tar.gz \
 && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# PYX
ADD scripts/default.sh scripts/overrides.sh /
ENV GIT_BRANCH master

RUN apk add dos2unix git --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ --allow-untrusted \
  && dos2unix /default.sh /overrides.sh \
  && git clone -b $GIT_BRANCH https://github.com/ajanata/PretendYoureXyzzy.git /project \
  && apk del dos2unix git \
  && chmod +x /default.sh /overrides.sh \
  && mkdir /overrides

ADD ./overrides/settings-docker.xml /usr/share/maven/ref/
VOLUME [ "/overrides" ]

WORKDIR /project
CMD [ "/default.sh" ]