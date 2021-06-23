FROM debian:latest

ARG user=jenkins
ARG group=jenkins
ARG http_port=8080
ARG agent_port=50000
ARG JENKINS_HOME=/var/jenkins_home

ENV JENKINS_HOME $JENKINS_HOME
ENV JENKINS_SLAVE_AGENT_PORT ${agent_port}

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

RUN apt-get update ;\
    apt-get install -y wget apt-utils gnupg openjdk-11-jdk;

RUN wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -; \
    sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list';
   
RUN apt-get update ;\
    apt-get install -y jenkins;

RUN usermod -u 105 jenkins
RUN groupmod -g 106 jenkins



CMD /etc/init.d/jenkins start;exec /bin/sh -c "trap : TERM INT; (while true; do sleep 1000; done) & wait"
