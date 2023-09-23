#!/usr/bin/with-contenv bashio

bashio::log.info "Starting SNMP server..."

exec /usr/sbin/snmpd \
   $(bashio::config 'args') \
   < /dev/null
