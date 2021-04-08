ARG RELEASE=archlinux:base-devel
FROM ${RELEASE}
MAINTAINER Morten Lund
RUN cat /etc/os-release

# WORKAROUND for glibc 2.33 and old Docker
# See https://github.com/actions/virtual-environments/issues/2658
# Thanks to https://github.com/lxqt/lxqt-panel/pull/1562
RUN patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst && \
    curl -LO "https://repo.archlinuxcn.org/x86_64/$patched_glibc" && \
    bsdtar -C / -xvf "$patched_glibc"

# set UTF-8 locale
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8

# OS Updates & Install
RUN pacman --noconfirm --needed -Syu git base-devel curl wget openssh

# Create test user & add to suduers
RUN useradd -m -s /bin/bash aur \
    && passwd -d aur \
    && echo 'aur ALL=(ALL) ALL' > /etc/sudoers.d/aur \
    && echo 'Defaults env_keep += "EDITOR"' >> /etc/sudoers.d/aur

# Add dotfiles & chown

# Temp fix
COPY arch.dockerfile /home/aur/dotfiles/arch.dockerfile
COPY archinstaller /home/aur/dotfiles/archinstaller
COPY colors-test /home/aur/dotfiles/colors-test
COPY config /home/aur/dotfiles/config
COPY custom /home/aur/dotfiles/custom
RUN rm /home/aur/dotfiles/custom/fzf.zsh
RUN rm /home/aur/dotfiles/custom/cargo.zsh
COPY dockerfile /home/aur/dotfiles/dockerfile
COPY gitconfig /home/aur/dotfiles/gitconfig
COPY hustly.sh /home/aur/dotfiles/hustly.sh
COPY install.sh /home/aur/dotfiles/install.sh
COPY LICENSE /home/aur/dotfiles/LICENSE
COPY minttyrc /home/aur/dotfiles/minttyrc
COPY mvsolution /home/aur/dotfiles/mvsolution
COPY plugins /home/aur/dotfiles/plugins
COPY Powershell /home/aur/dotfiles/Powershell
COPY README.md /home/aur/dotfiles/README.md
COPY tags /home/aur/dotfiles/tags
COPY tmux.conf /home/aur/dotfiles/tmux.conf
COPY update_oh_my_zsh.sh /home/aur/dotfiles/update_oh_my_zsh.sh
COPY zshrc /home/aur/dotfiles/zshrc

RUN chown -R aur:aur /home/aur

# Switch user
USER aur
ENV HOME /home/aur
WORKDIR /home/aur/dotfiles/archinstaller

# Run Setup
#RUN ./omz-install.sh
#RUN ./rust-cargo-install.sh
#RUN ./nvim-install.sh
#RUN ./sysutils-install.sh
