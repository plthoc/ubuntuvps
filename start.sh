#!/bin/bash

# Fix dbus machine-id if missing
if [ ! -f /var/lib/dbus/machine-id ]; then
    dbus-uuidgen > /var/lib/dbus/machine-id
fi

# Start dbus properly with full session
rm -f /var/run/dbus/pid
mkdir -p /var/run/dbus
dbus-daemon --system --fork
sleep 1

# Fix X11 socket directory
mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

# Start pulseaudio
pulseaudio --start --system --disallow-exit --disable-shm 2>/dev/null || true
sleep 1

# Fix xrdp ssl cert permissions
if [ -f /etc/ssl/private/ssl-cert-snakeoil.key ]; then
    chmod 640 /etc/ssl/private/ssl-cert-snakeoil.key
    chown root:ssl-cert /etc/ssl/private/ssl-cert-snakeoil.key
fi

# Ensure .xsession is correct
echo "export DBUS_SESSION_BUS_ADDRESS=\$(dbus-launch --sh-syntax | grep DBUS_SESSION_BUS_ADDRESS | cut -d= -f2-)" > /root/.xsession
echo "startxfce4" >> /root/.xsession
chmod 700 /root/.xsession

# Set XFCE as xrdp session
echo "startxfce4" > /etc/xrdp/startwm.sh
chmod +x /etc/xrdp/startwm.sh

# Start xrdp
service xrdp start
sleep 2

echo "==========================================="
echo " RDP ready on port 3389"
echo " User: root | Password: root"
echo "==========================================="

# Keep container alive and stream logs
tail -f /var/log/xrdp-sesman.log /var/log/xrdp.log 2>/dev/null || tail -f /dev/null
