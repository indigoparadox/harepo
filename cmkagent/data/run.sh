#!/usr/bin/with-contenv bashio

DROPBEAR_KEY=/data/dropbear.key

if [ ! -f "$DROPBEAR_KEY" ]; then
   bashio::log.info "Creating SSH key..."
   /usr/bin/dropbearkey -f "$DROPBEAR_KEY" -t rsa -s 4096
fi

bashio::log.info "Starting SSH server..."

/usr/sbin/dropbear -p 6556 -F -E -r "$DROPBEAR_KEY"

