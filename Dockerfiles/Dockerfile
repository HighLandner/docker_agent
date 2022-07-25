FROM jenkins/inbound-agent:alpine as jnlp

FROM maven:3.6.3-jdk-8-slim

RUN apt-get update && \
    apt-get install -y \
        git \
        libfontconfig1 \
        libfreetype6 \
        nginx

COPY bootstrap.sh /usr/share/jenkins/
RUN chmod +x bootstrap.sh && /usr/share/jenkins/bootstrap.sh

ARG user=jenkins

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

USER ${user}
ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
