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
RUN apt-get -y install build-essential libreadline-dev libssl-dev libpq5 libpq-dev libreadline5 libsqlite3-dev libpcap-dev git-core autoconf postgresql pgadmin3 curl zlib1g-dev libxml2-dev libxslt1-dev vncviewer libyaml-dev curl zlib1g-dev nmap


# install Java
#RUN apt-get update
#RUN apt-get -y install software-properties-common python-software-properties
#RUN add-apt-repository -y ppa:webupd8team/java
#RUN apt-get update
#RUN apt-get -y install oracle-java8-installer

# install Ruby

USER seh
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import -
RUN curl -L https://get.rvm.io | bash -s stable
RUN source home/seh/.rvm/scripts/rvm
RUN echo "source /home/seh/.rvm/scripts/rvm" >> /home/seh/.bashrc
RUN source /home/seh/.bashrc
RUN RUBYVERSION=$(wget https://raw.githubusercontent.com/rapid7/metasploit-framework/master/.ruby-version -q -O - )
RUN sudo rvm install $RUBYVERSION
RUN rvm use $RUBYVERSION --default
RUN ruby -v

# run tmux when started

CMD tmux new -s docker_mux