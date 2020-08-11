ARG RELEASE=ubuntu:18.04
FROM ${RELEASE}
MAINTAINER Morten Lund
RUN cat /etc/os-release

# OS Updates & Install
RUN apt-get -y update
RUN apt-get -y install sudo

# Create test user & add to suduers
RUN useradd -m -s /bin/bash tester
RUN usermod -aG sudo tester
RUN echo "tester    ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers

# Add dotfiles & chown
ADD ./install.sh /home/tester/install.sh
RUN chown -R tester:tester /home/tester

# Switch user
USER tester
ENV HOME /home/tester
WORKDIR /home/tester

# Run Setup
RUN cat /home/tester/install.sh | sh
RUN hustly -v
RUN hustly -d install
RUN hustly -d check
RUN hustly -d update
RUN hustly -d check
RUN hustly -d uninstall
