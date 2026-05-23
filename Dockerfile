FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386

RUN apt update && apt install -y \
    xrdp \
    xfce4 \
    xfce4-goodies \
    xfce4-terminal \
    xorg \
    dbus \
    dbus-x11 \
    sudo \
    curl \
    wget \
    nano \
    net-tools \
    policykit-1 \
    pulseaudio \
    pulseaudio-utils \
    wine \
    wine32 \
    firefox \
    ssl-cert && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Set root password
RUN echo "root:root" | chpasswd

# Allow root X access
RUN sed -i 's/^allowed_users=.*/allowed_users=anybody/' /etc/X11/Xwrapper.config 2>/dev/null || \
    echo "allowed_users=anybody" >> /etc/X11/Xwrapper.config

# Generate machine-id for dbus
RUN mkdir -p /var/run/dbus /var/lib/dbus && \
    dbus-uuidgen > /var/lib/dbus/machine-id

# Configure xrdp: low encryption + rdp security layer (same as original)
RUN sed -i 's/crypt_level=high/crypt_level=low/' /etc/xrdp/xrdp.ini && \
    sed -i 's/security_layer=negotiate/security_layer=rdp/' /etc/xrdp/xrdp.ini

# Fix xrdp cert permissions
RUN adduser xrdp ssl-cert

# Set default session
RUN echo "startxfce4" > /root/.xsession && chmod 700 /root/.xsession
RUN echo "startxfce4" > /etc/xrdp/startwm.sh && chmod +x /etc/xrdp/startwm.sh

COPY start.sh /start.sh
COPY pulse-client.conf /etc/pulse/client.conf
RUN chmod +x /start.sh

EXPOSE 3389

CMD ["/start.sh"]
