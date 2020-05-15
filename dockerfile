FROM ubuntu:18.04
MAINTAINER Morten Lund

# From: https://www.jamesridgway.co.uk/dotfiles-with-github-travis-ci-and-docker/

# OS Updates & Install
RUN apt-get -y update
RUN apt-get -y install sudo curl git gcc

# Create test user & add to suduers
RUN useradd -m -s /bin/bash tester
RUN usermod -aG sudo tester
RUN echo "tester    ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers

# Add dotfiles & chown
ADD . /home/tester/dotfiles
RUN chown -R tester:tester /home/tester

# Switch user
USER tester
ENV HOME /home/tester

# Change working directory
WORKDIR /home/tester/dotfiles
RUN git clean -Xdf
RUN git clean -xdf

# Run Setup
RUN ./hustly.sh -d install
RUN ./hustly.sh -d check
RUN ./hustly.sh -d update
RUN ./hustly.sh -d uninstall
