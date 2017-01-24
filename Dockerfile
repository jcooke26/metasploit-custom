# use the latest version of Ubuntu - possibly change this down to 14.04 for a stable release if necessary

FROM ubuntu:latest

# install everything into /opt and as user root
WORKDIR /opt
USER root

# add the user "seh" for later
RUN useradd -m -s /bin/bash seh
RUN apt-get update && apt-get -y install sudo
RUN echo "seh ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# install tmux as a viewer
RUN apt-get update && apt-get -y install tmux

# install Dependencies
RUN apt-get update
RUN apt-get -y install build-essential libreadline-dev \
 libssl-dev libpq5 libpq-dev libreadline5 libsqlite3-dev \
 libpcap-dev git-core autoconf postgresql pgadmin3 curl \
 zlib1g-dev libxml2-dev libxslt1-dev vncviewer libyaml-dev\
  curl zlib1g-dev nmap wget openjdk-8-jre


# install Java
#RUN apt-get update
#RUN apt-get -y install software-properties-common python-software-properties
#RUN add-apt-repository -y ppa:webupd8team/java
#RUN apt-get update
#RUN apt-get -y install oracle-java8-installer

# install Ruby - borrowed from remnux script
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import
RUN curl -L https://get.rvm.io | bash -s stable 
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.3.1"
RUN /bin/bash -l -c "rvm use 2.3.1 --default"
RUN /bin/bash -l -c "source /usr/local/rvm/scripts/rvm"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
RUN /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && which bundle"
RUN /bin/bash -l -c "which bundle"

#configure postgres
USER root
RUN service postgresql start
#USER postgres
#RUN createuser msf --no-password -S -R -D

# run tmux when started

CMD tmux new -s docker_mux