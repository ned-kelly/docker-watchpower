# Watchpower web-based (headless) daemon - Based on docker ubuntu 16.04 LTS
FROM ubuntu:bionic
MAINTAINER DN "david@nedved.com.au"

# Configure Environment Variables
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_ARG0=/sbin/entrypoint.sh \
    VNC_GEOMETRY=1600x1200 \
    VNC_PASSWD='watchpower' \
    USER_PASSWD='' \
    DEBIAN_FRONTEND=noninteractive

RUN groupadd user && useradd -m -g user user

# Pull in S6 Overlay & Tiger VNC
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.18.1.5/s6-overlay-amd64.tar.gz /tmp/s6-overlay-amd64.tar.gz

# Setup VNC Server
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
        python git \
        ca-certificates wget curl locales \
        sudo nginx \
        xorg openbox && \
    tar -xvf /tmp/s6-overlay-amd64.tar.gz && \
    # workaround for https://github.com/just-containers/s6-overlay/issues/158
    ln -s /init /init.entrypoint && \
    locale-gen en_US.UTF-8 && \
    # novnc
    mkdir -p /app/src && \
    git clone --depth=1 https://github.com/novnc/noVNC.git /app/src/novnc && \
    git clone --depth=1 https://github.com/novnc/websockify.git /app/src/websockify && \
    apt-get autoremove -y && \
    apt-get clean

# Auto-set timezone based on location...
RUN apt install -y python-pip && \
    pip install -U tzupdate

RUN apt-get install -y tigervnc-common tigervnc-standalone-server && \
    apt-get install -y xdg-utils wmctrl --fix-missing

# copy files
COPY ./docker-root /
RUN apt install -y xterm

# Install Watchpower Dependences
RUN cd /app && tar -xzf watchpower*.tar.gz

EXPOSE 9000

ENTRYPOINT ["/init.entrypoint"]
CMD ["start"]
