FROM dorowu/ubuntu-desktop-lxde-vnc:focal

RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN apt-get update -qq \
	&&  apt-get purge -y -qq google-chrome-stable \
	&&  apt-get upgrade -y -qq

# Set Area and Timezone
RUN echo 'tzdata tzdata/Areas select Asia' | debconf-set-selections
RUN echo 'tzdata tzdata/Zones/Asia select Chongqing' | debconf-set-selections
RUN DEBIAN_FRONTEND="noninteractive" apt install -y tzdata

# Install required packages for FriendlyElec's boards
RUN apt-get -y install texinfo git
RUN git clone https://github.com/friendlyarm/build-env-on-ubuntu-bionic
RUN chmod 755 build-env-on-ubuntu-bionic/install.sh
RUN build-env-on-ubuntu-bionic/install.sh
RUN rm -rf build-env-on-ubuntu-bionic
RUN update-alternatives --install $(which python) python /usr/bin/python2.7 20
RUN git clone https://github.com/friendlyarm/repo
RUN cp repo/repo /usr/bin/

# Install other required packages
RUN 	apt-get install -y --no-install-recommends -qq \
	software-properties-common locales \
	nano bash-completion lxtask openssh-server xdotool filezilla putty dnsutils \
	papirus-icon-theme fonts-noto-cjk fonts-noto-cjk-extra obconf lxappearance-obconf vim terminator tree rsync \
    poppler-utils shared-mime-info mime-support
RUN		apt-get clean

# Customizations : remove unused, change settings, copy conf files
COPY files /

# SSHD run bugfix
RUN mkdir -p /run/sshd
