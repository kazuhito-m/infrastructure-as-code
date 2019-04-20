FROM docker/compose:1.25.0-rc1-alpine

LABEL maintainer "kazuhito_m"

# OpenJDK install 
# (from https://github.com/docker-library/openjdk/blob/1398299a268f339254a94b606113d1627dec342e/13/jdk/alpine/Dockerfile)

ENV JAVA_HOME /opt/openjdk-13
ENV PATH $JAVA_HOME/bin:$PATH

ENV JAVA_VERSION 13-ea+19
ENV JAVA_URL https://download.java.net/java/early_access/alpine/19/binaries/openjdk-13-ea+19_linux-x64-musl_bin.tar.gz
ENV JAVA_SHA256 010ea985fba7e3d89a9170545c4e697da983cffc442b84e65dba3baa771299a5

ENV JAVA_OPENJDK_BIN "openjdk-13-ea+19_linux-x64-musl_bin.tar.gz"
COPY ./resources/${JAVA_OPENJDK_BIN} /${JAVA_OPENJDK_BIN}

RUN set -eux; \
	mkdir -p "$JAVA_HOME"; \
	tar --extract --file /${JAVA_OPENJDK_BIN} --directory "$JAVA_HOME" --strip-components 1; \
	rm /${JAVA_OPENJDK_BIN}; \
	java -Xshare:dump; \
	java --version; \
	javac --version

# Jenkins Agent install
# (from )https://github.com/jenkinsci/docker-slave/blob/master/Dockerfile-alpine)

ARG VERSION=3.29

ENV HOME /home/root
ARG AGENT_WORKDIR=/var/lib/jenkins
ENV AGENT_BIN /usr/share/jenkins/slave.jar

RUN apk add --update --no-cache curl bash git git-lfs openssh-client openssl procps \
  && curl --create-dirs -fsSLo ${AGENT_BIN} https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 ${AGENT_BIN} \
  && apk del curl

ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir -p /home/root/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/root/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/rootjava -jar ${AGENT_BIN} -jnlpUrl ${JNLP_URL} -secret ${SECRET} -workDir ${AGENT_WORKDIR}

ENTRYPOINT java -jar ${AGENT_BIN} -jnlpUrl ${JNLP_URL} -secret ${SECRET} -workDir ${AGENT_WORKDIR}