# use the latest version of Ubuntu - possibly change this down to 14.04 for a stable release if necessary

FROM ubuntu:latest

# install everything into /opt and as user root

WORKDIR /opt
USER root

# install tmux as a viewer
RUN apt-get update && apt-get -y install tmux

# install Dependencies
RUN apt-get update
RUN apt-get -y install build-essential libreadline-dev libssl-dev libpq5 libpq-dev libreadline5 libsqlite3-dev libpcap-dev git-core autoconf postgresql pgadmin3 curl zlib1g-dev libxml2-dev libxslt1-dev vncviewer libyaml-dev curl zlib1g-dev nmap


# install Java
#RUN apt-get update
#RUN apt-get -y install software-properties-common python-software-properties
#RUN add-apt-repository -y ppa:webupd8team/java
#RUN apt-get update
#RUN apt-get -y install oracle-java8-installer

# run tmux when started

CMD tmux new -s docker_mux