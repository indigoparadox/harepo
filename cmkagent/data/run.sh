#!/usr/bin/with-contenv bashio

DROPBEAR_KEY=/data/dropbear.key
SSH_DATA_PATH=/etc/dropbear
AUTH_KEYS_PATH=$SSH_DATA_PATH/authorized_keys

if [ ! -f "$DROPBEAR_KEY" ]; then
   bashio::log.info "Creating SSH key..."
   /usr/bin/dropbearkey -f "$DROPBEAR_KEY" -t rsa -s 4096
fi

bashio::log.info "Setting up authorized keys..."

mkdir -p "$SSH_DATA_PATH"
echo "$(bashio::config "authorized_keys")" > "$AUTH_KEYS_PATH"
chmod 600 "$AUTH_KEYS_PATH"

bashio::log.info "Starting SSH server..."

/usr/sbin/dropbear -p 6556 -F -E -r "$DROPBEAR_KEY"

