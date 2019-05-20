#!/bin/bash
set -e

## ProxySQL entrypoint
## ===================
##
## Supported environment variable:
##
## MONITOR_CONFIG_CHANGE={true|false}
## - Monitor /etc/proxysql.cnf for any changes and reload ProxySQL automatically

# If command has arguments, prepend proxysql
if [ "${1:0:1}" = '-' ]; then
	CMDARG="$@"
fi

if [ $MONITOR_CONFIG_CHANGE ]; then

	echo 'Env MONITOR_CONFIG_CHANGE=true'
	CONFIG=/etc/proxysql.cnf
	oldcksum=$(cksum ${CONFIG})

	# Start ProxySQL in the background
	proxysql --reload -f $CMDARG &

	echo "Monitoring $CONFIG for changes.."
	inotifywait -e modify,move,create,delete -m --timefmt '%d/%m/%y %H:%M' --format '%T' ${CONFIG} | \
	while read date time; do
		newcksum=$(cksum ${CONFIG})
		if [ "$newcksum" != "$oldcksum" ]; then
			echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
			echo "At ${time} on ${date}, ${CONFIG} update detected."
			echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
			oldcksum=$newcksum
			echo "Reloading ProxySQL.."
		        killall -15 proxysql
			proxysql --initial --reload -f $CMDARG
		fi
	done
fi

# Set supervisord to configure pmm-client if monitoring is enabled
if [ "$ENABLE_PMM_MONITORING" == "true" ]; then
	if [[ -f "/etc/supervisord.conf" && -f "/pmm-client-conf.sh" ]]; then
    	/usr/bin/supervisord -c /etc/supervisord.conf
	else
		echo  "could not retrieve the /etc/supervisord.conf file"
		exit 1
	fi
fi

# Start ProxySQL with PID 1
exec proxysql -f $CMDARG
