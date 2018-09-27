FROM jenkins/jnlp-slave:alpine

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
    
# Install the latest Docker CE binaries
RUN apk -U --no-cache \
	--allow-untrusted add \
    docker \
    py-pip \
    && pip install docker-compose

# Minimize size
RUN rm -rf /var/lib/apt/lists/* \
    /var/cache/apk/* \
    /usr/share/man \
/tmp/*


USER jenkins
