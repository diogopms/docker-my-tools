FROM debian:buster-slim
MAINTAINER Diogo Serrano <info@diogoserrano.com>

RUN apt-get update;
RUN apt-get -y install iputils-ping telnet postgresql redis curl htop;

RUN curl -sL https://deb.nodesource.com/setup_11.x -o /tmp/nodesource_setup.sh
RUN chmod +x /tmp/nodesource_setup.sh
RUN /tmp/nodesource_setup.sh

RUN apt-get -y install -y nodejs

RUN curl -sL "https://get.helm.sh/helm-v2.16.1-linux-amd64.tar.gz" -o /tmp/helm-v2.16.1-linux-amd64.tar.gz
RUN tar -C /tmp -zxf /tmp/helm-v2.16.1-linux-amd64.tar.gz
RUN chmod +x /tmp/linux-amd64/helm; mv /tmp/linux-amd64/helm /usr/local/bin/helm
RUN chmod +x /tmp/linux-amd64/tiller; mv /tmp/linux-amd64/tiller /usr/local/bin/tiller

RUN curl -sL https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/linux/amd64/kubectl -o kubectl
RUN chmod +x ./kubectl; mv ./kubectl /usr/local/bin/kubectl

RUN curl -sL https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64 -o stern_linux_amd64
RUN chmod +x ./stern_linux_amd64; mv ./stern_linux_amd64 /usr/local/bin/stern
