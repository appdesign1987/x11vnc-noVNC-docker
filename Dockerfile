###################################################################################
# Thanks to Creator of noVNC : Joel Martin (github@martintribe.org).              #
# https://novnc.com/info.html                                                     #
# Thanks to Oleksii S. Malakhov the owner of q4wine, 
# https://sourceforge.net/projects/q4wine/                                        #
###################################################################################

FROM ubuntu:20.04
MAINTAINER Jeroen v Drongelen

# environment variables
ENV HOME=/root \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \  
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get full-upgrade --auto-remove --purge -y && rm -rf /var/lib/apt/lists/*

RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections
RUN echo "Set disable_coredump false" >> /etc/sudo.conf
COPY src/etc/apt /etc/apt
RUN apt-get update
RUN apt-get install -y apt-utils aptitude sudo
RUN echo "********************** apt-get upgrade **********************" && apt-get -o Dpkg::Options::="--force-confnew" --fix-broken -y --purge --auto-remove --allow-downgrades --allow-remove-essential --allow-change-held-packages upgrade
RUN aptitude install \
  -y \
  ubuntu-desktop_ \
  ubuntu-desktop-minimal_ \
  gnome-initial-setup_ \
  initramfs-tools_ \
  brltty_ \
  orca_ \
  speech-dispatcher_ \
  kernelstub_ \
  lilo_ \
  foomatic-db_ \
  foomatic-db-engine_ \
  initramfs-tools_

RUN aptitude install \
  pop-desktop+ flatpak+ \
  -y \
  ubuntu-desktop_ \
  ubuntu-desktop-minimal_ \
  gnome-initial-setup_ \
  initramfs-tools_ \
  brltty_ \
  orca_ \
  speech-dispatcher_ \
  kernelstub_ \
  lilo_ \
  foomatic-db_ \
  foomatic-db-engine_ \
  initramfs-tools_
  
RUN flatpak remote-add --if-not-exists "flathub" "https://flathub.org/repo/flathub.flatpakrepo"

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
WORKDIR /root/
RUN git clone https://github.com/novnc/noVNC.git /root/noVNC \
        && git clone https://github.com/novnc/websockify /root/noVNC/utils/websockify \
        && rm -rf /root/noVNC/.git \
	&& rm -rf /root/noVNC/utils/websockify/.git 

COPY bash.bashrc /etc/bash.bashrc
EXPOSE 8080
CMD ["/usr/bin/supervisord"]
