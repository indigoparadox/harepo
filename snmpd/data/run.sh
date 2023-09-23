#!/usr/bin/with-contenv bashio

bashio::log.info "Building SNMP config..."

SNMPD_IP=`ip addr show eth0 | grep inet | sed 's/\s*inet \([0-9.]*\).*/\1/g'`

SNMPD_CONFIG="/etc/snmp/snmpd.conf"
{
   echo "agentaddress udp:${SNMPD_IP}:161"
   echo "com2sec readonly default $(bashio::config "community")"
   echo "syslocation $(bashio::config "location")"
   echo "syscontact $(bashio::config "name") <$(bashio::config "email")>"
   echo "group MyROGroup v2c readonly"
   echo "view all included .1 80"
   echo "access MyROGroup ''      any       noauth    exact  all    none   none noauth"
   echo "$(bashio::config "config")"
} > "${SNMPD_CONFIG}"

cat "${SNMPD_CONFIG}"

bashio::log.info "Starting SNMP server..."


exec /usr/sbin/snmpd \
   -c "${SNMPD_CONFIG}" \
   $(bashio::config 'args') \
   < /dev/null
