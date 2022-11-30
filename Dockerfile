FROM debian:stable-slim
LABEL Diogo Serrano <info@diogoserrano.com>

RUN apt-get update;
RUN apt-get -y install iputils-ping telnet postgresql redis curl htop kafkacat;

RUN curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesource_setup.sh
RUN chmod +x /tmp/nodesource_setup.sh
RUN /tmp/nodesource_setup.sh

RUN apt-get -y install -y nodejs

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh
RUN rm get_helm.sh

RUN curl -sL https://storage.googleapis.com/kubernetes-release/release/v1.19.16/bin/linux/amd64/kubectl -o kubectl
RUN chmod +x ./kubectl; mv ./kubectl /usr/local/bin/kubectl

RUN curl -sL https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64 -o stern_linux_amd64
RUN chmod +x ./stern_linux_amd64; mv ./stern_linux_amd64 /usr/local/bin/stern
