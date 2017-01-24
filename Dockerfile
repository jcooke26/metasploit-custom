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
RUN apt-get -y install build-essential libreadline-dev libssl-dev libpq5 libpq-dev libreadline5 libsqlite3-dev libpcap-dev git-core autoconf postgresql pgadmin3 curl zlib1g-dev libxml2-dev libxslt1-dev vncviewer libyaml-dev curl zlib1g-dev nmap wget


# install Java
#RUN apt-get update
#RUN apt-get -y install software-properties-common python-software-properties
#RUN add-apt-repository -y ppa:webupd8team/java
#RUN apt-get update
#RUN apt-get -y install oracle-java8-installer

# install Ruby
USER seh
WORKDIR /home/seh
RUN git clone git://github.com/sstephenson/rbenv.git .rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> .bashrc
RUN echo 'eval "$(rbenv init -)"' >> .bashrc
RUN exec $SHELL

RUN git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc

RUN git clone git://github.com/dcarley/rbenv-sudo.git ~/.rbenv/plugins/rbenv-sudo

RUN exec $SHELL

RUN RUBYVERSION=$(wget https://raw.githubusercontent.com/rapid7/metasploit-framework/master/.ruby-version -q -O - )
RUN rbenv install $RUBYVERSION
RUN rbenv global $RUBYVERSION
RUN ruby -v

CMD tmux new -t ruby-docker
#configure postgres
USER root
RUN service postgresql start
USER postgres
RUN createuser msf --no-password -S -R -D

# run tmux when started

CMD tmux new -s docker_mux