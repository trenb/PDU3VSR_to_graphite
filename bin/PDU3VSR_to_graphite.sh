#!/bin/bash
# Debugging options
#set -xv
#exec 2>/tmp/PDU3VSR_to_graphite.sh.debug
#
# Script to read in the metrics from a TrippLite PDU because
# they don't see fit to export them via SNMP.
#     SHAME ON YOU TRIPPLITE
#
# What I've tested this on:
#  - Tripp Lite 3 phase vertical PDU's model PDU3VSR
#    - Firmware 12.04.0055
#
# I have not tested this on any other model of Tripp Lite,
# or on any other firmware revision. This should work on the
# NON-java releases of the firmware. YMMV.
#
# Tren Blackburn - November 2014
#
# # Default settings are stored in /usr/local/etc/PDU3VSR_to_graphite.conf
# # by default. You can also specify a config file from the command line
# # by specifying it after the script name if you're monitoring more than
# # one PDU.
# #
# # If you don't have one, make one from the following:
# #
# # FQDN of the PDU you want to get metrics for
# PDUHOST=fqdn.pdu.local
# # Account to use. In my case only manager and admin work.
# PDUUSER=manager
# # Password for the above account
# PDUPASS=manager_password
# # Number of power sockets your PDU has
# PDUPORT=number_of_ports_your_pdu_has
# # FQDN of your graphite server
# GRAPHITE=fqdn.graphite.local
# # Port your carbon-cache or relay or aggregator is listening on
# GRAPHITEPORT=2003
# # How often you want this to run
# INTERVAL=60
#
# Make sure a conf file is specified on the command line
# or that a default conf is setup
#
CONF=$1
DEFAULTCONF=/usr/local/etc/PDU3VSR_to_graphite.conf
if [ -e "$DEFAULTCONF" ] && [ -z "$CONF" ]
then
  echo "Default configuration found at $DEFAULTCONF"
  echo -e "\r"
  CONF=$DEFAULTCONF
elif [ -z "$CONF" ]
then
  echo "No configuration file specified"
  echo "Please create it, and specify on the command line,"
  echo "or put at $DEFAULTCONF"
  echo -e "\r"
  echo "This should help get you started:"
  echo -e "\r"
  tail -n+20 $0 | head -n21 | sed 's/^# //g'
  exit 99
elif [ ! -e "$CONF" ]
then
  echo "Missing $CONF"
  echo "Please create it and try again."
  echo "This should help get you started:"
  echo -e "\r"
  tail -n+20 $0 | head -n21 | sed 's/^# //g'
  exit 99
fi

# Load in the configuration file options, and verify they're all set.
source "$CONF"
if [ -z "$PDUHOST" ] || [ -z "$PDUUSER" ] || [ -z "$PDUPASS" ] || \
   [ -z "$PDUPORT" ] || [ -z "$GRAPHITE" ] || [ -z "$GRAPHITEPORT" ] || \
   [ -z "$INTERVAL" ]
then
  echo "Missing one or more options in $CONF"
  echo -e "\r"
  echo "PDUHOST      = $PDUHOST"
  echo "PDUUSER      = $PDUUSER"
  echo "PDUPASS      = $PDUPASS"
  echo "PDUPORT      = $PDUPORT"
  echo "GRAPHITE     = $GRAPHITE"
  echo "GRAPHITEPORT = $GRAPHITEPORT"
  echo "INTERVAL     = $INTERVAL"
  exit 99
fi
# Swap dots to underscores to make compatible with graphite
PDUHOSTNODOT=$(echo $PDUHOST | tr '.' '_')

while $(sleep $INTERVAL)
do
  # The TrippLite PDU's have a bad habit of not sending what I asked every once in a while to my curl command
  # Put this in a while loop to ensure we actually get data. However, to ensure it doesn't loop
  # FOREVER, put in a counter and increment on each loop, until it hits 10.
  count=0
  PDU=""
  while [ -z "$PDU" ] && [ $count != 10 ]
  do
    PDU=$(curl -s --max-time 10 --user "$PDUUSER:$PDUPASS" http://$PDUHOST/actions/action_load_list.htm | grep ^loadlist)
    DATE=$(date +%s)
    let count+=1
  done

  if [ -z "$PDU" ]
  then
    echo "Can't get per port metrics from your PDU at $PDUHOST."
    echo "Please check your configuration settings:"
    echo -e "\r"
    echo "PDUHOST      = $PDUHOST"
    echo "PDUUSER      = $PDUUSER"
    echo "PDUPASS      = $PDUPASS"
    echo "PDUPORT      = $PDUPORT"
    echo "GRAPHITE     = $GRAPHITE"
    echo "GRAPHITEPORT = $GRAPHITEPORT"
    echo "INTERVAL     = $INTERVAL"
    exit 99
  fi

  for portnum in $(seq 1 $PDUPORT)
  do
    # Get the matching port and reformat the line to keep only port name, usage in A, usage in W
    declare Port${portnum}=$(echo "$PDU" | awk '$1 == "loadlist['${portnum}']" {print $4 $5 $6 $7}' | awk -F '"' '{print "Port"'${portnum}'":"$4":"$6":"$8}')
    declare PORT=Port${portnum}
    # Get the port label
    declare PORT${portnum}_N=$(echo ${!PORT} | awk -F ':' '{if ($2=="") print "EMPTY"; else print $2}')
    declare PORT_N=PORT${portnum}_N
    # Get the usage in Amps
    declare PORT${portnum}_A=$(echo ${!PORT} | awk -F ':' '{print $3}' | awk -F 'A' '{print $1'})
    declare PORT_A=PORT${portnum}_A
    # Get the usage in Watts
    declare PORT${portnum}_W=$(echo ${!PORT} | awk -F ':' '{print $4}' | awk -F 'W' '{print $1'})
    declare PORT_W=PORT${portnum}_W
    # Pipe the metrics to graphite
    echo "Tripp-Lite.PDU3VSR.$PDUHOSTNODOT.Port${portnum}-${!PORT_N}.usageinA ${!PORT_A} $DATE" | nc ${GRAPHITE} ${GRAPHITEPORT}
    #echo "Tripp-Lite.PDU3VSR.$PDUHOSTNODOT.Port${portnum}-${!PORT_N}.usageinA ${!PORT_A} $DATE"
    echo "Tripp-Lite.PDU3VSR.$PDUHOSTNODOT.Port${portnum}-${!PORT_N}.usageinW ${!PORT_W} $DATE" | nc ${GRAPHITE} ${GRAPHITEPORT}
    #echo "Tripp-Lite.PDU3VSR.$PDUHOSTNODOT.Port${portnum}-${!PORT_N}.usageinW ${!PORT_W} $DATE"
  done
  unset PORT
  unset PORT_N
  unset PORT_A
  unset PORT_W
done