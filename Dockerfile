FROM debian
MAINTAINER Diogo Serrano <info@diogoserrano.com>

RUN apt-get update;
RUN apt-get -y install iputils-ping telnet postgresql redis curl htop;

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl; mv ./kubectl /usr/local/bin/kubectl

RUN curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
RUN chmod +x nodesource_setup.sh
RUN ./nodesource_setup.sh

RUN apt-get -y install -y nodejs

RUN echo "Done :)"
