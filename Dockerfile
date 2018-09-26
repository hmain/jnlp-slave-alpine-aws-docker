FROM jenkins/jnlp-slave:alpine

ENV DOCKER_VERSION latest
ENV DOCKER_COMPOSE_VERSION latest

#curl is currently broken on alpine, either install curl-dev to upgrade libcurl or use wget instead
User root
RUN apk --no-cache update && \
    apk --no-cache add --update python && \
    wget "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -O "awscli-bundle.zip" && \
    unzip awscli-bundle.zip && \
    chmod +x ./awscli-bundle/install && \
    ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \
    rm awscli-bundle.zip && \
    rm -rf awscli-bundle && \
    rm /var/cache/apk/* \
    
RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz \
    && tar --strip-components=1 -xvzf docker-${DOCKER_VERSION}.tgz -C /usr/local/bin \
    && chmod -R +x /usr/local/bin/docker

RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose \
&& chmod +x /usr/local/bin/docker-compose


USER jenkins
