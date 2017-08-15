#!/bin/bash

ACTION=${1}
IFACE=${2}

function print_help_and_exit
{
	echo "SOS - HELP"
	exit 0
}

function start_fw
{
	echo "setting up iptables rules for ${IFACE}"
	iptables -N DYN_OUTPUT_${IFACE}
	iptables -A OUTPUT -o ${IFACE} -j DYN_OUTPUT_${IFACE}

	iptables -N DYN_INPUT_${IFACE}
	iptables -A DYN_INPUT_${IFACE} -m state --state established,related -j ACCEPT
	iptables -A DYN_INPUT_${IFACE} -m limit -j LOG
	iptables -A DYN_INPUT_${IFACE} -j DROP
	iptables -A INPUT -i ${IFACE} -j DYN_INPUT_${IFACE}
}

function stop_fw
{
	echo "removing iptables rules for ${IFACE}"
	iptables -D OUTPUT -o ${IFACE} -j DYN_OUTPUT_${IFACE}
	iptables -F DYN_OUTPUT_${IFACE}
	iptables -X DYN_OUTPUT_${IFACE}

	iptables -D INPUT -i ${IFACE} -j DYN_INPUT_${IFACE}
	iptables -F DYN_INPUT_${IFACE}
	iptables -X DYN_INPUT_${IFACE}
}

[ -z "$ACTION" ] && print_help_and_exit
[ -z "$IFACE" ] && print_help_and_exit

case ${ACTION} in
	start)
		start_fw
	;;
	stop)
		stop_fw
	;;
	*)
		print_help_and_exit
	;;
esac
