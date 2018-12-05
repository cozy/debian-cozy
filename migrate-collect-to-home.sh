#!/usr/bin/env bash
export COZY_ADMIN_PASSWORD="$(cat /etc/cozy/.cozy-admin-passphrase)"

echo "Migrating collect to home"
cozy-stack instances ls | awk '{print $1}' | while read domain; do
	echo "  Migrating ${domain}"
	echo "    Installing home"
	cozy-stack apps install home --domain "${domain}" 1>/dev/null
	echo "    Uninstalling collect"
	cozy-stack apps uninstall collect --domain "${domain}" 1>/dev/null
done
