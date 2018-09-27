FROM jenkins/jnlp-slave:alpine

ENV DOCKER_VERSION latest
ENV DOCKER_COMPOSE_VERSION 1.22.0
USER root
RUN apk update
# Install base and dev packages
RUN apk add --no-cache --virtual .build-deps
RUN apk add bash
# Install build packages
RUN apk add make && apk add curl && apk add openssh
# Install git
RUN apk add git
# Set timezone to UTC by default
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

# Install aws-cli
RUN apk -Uuv add groff less python py-pip
RUN pip install awscli
RUN apk --purge -v del py-pip
RUN rm /var/cache/apk/*
RUN aws --version
    
RUN wget "https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz" -O "docker-${DOCKER_VERSION}.tgz" \
    && tar --strip-components=1 -xvzf docker-${DOCKER_VERSION}.tgz -C /usr/local/bin \
    && chmod -R +x /usr/local/bin/docker

RUN wget "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64" -O "/usr/local/bin/docker-compose" \
&& chmod +x /usr/local/bin/docker-compose


USER jenkins
