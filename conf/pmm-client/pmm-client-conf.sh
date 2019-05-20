#!/bin/bash
set -e

echo "###############################"
echo "#### PMM-CLIENT-CONF-BEGIN ####"
echo "###############################"

echo "#### Connect to the PMM SERVER ####"
pmm-admin config --server ${PMM_SERVER} --client-name ProxySQL-$(hostname -s)
echo "#### Add Rules ####"
pmm-admin remove --all
pmm-admin add proxysql --dsn "stats:stats@tcp(127.0.0.1:${PROXYSQL_STATS_PORT})/"
echo "#### Check Connection status ####"
pmm-admin list
sleep 60
pmm-admin check-network

echo "#############################"
echo "#### PMM-CLIENT-CONF-END ####"
echo "#############################"
