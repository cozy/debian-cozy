#!/usr/bin/env bash
export COZY_ADMIN_PASSWORD="$(cat /etc/cozy/.cozy-admin-passphrase)"
COCLYCO="$(which cozy-coclyco)"

function coclyco {
	[ -n "${COCLYCO}" ] && "${COCLYCO}" "${@}"
}

function app_installed {
	DOMAIN="${1}"
	APP="${2}"
	cozy-stack apps show --domain "${DOMAIN}" "${APP}" &>/dev/null
}

function install_app {
	DOMAIN="${1}"
	APP="${2}"
	if app_installed "${@}"; then
		echo "    App ${APP} already installed, nothing to do"
	else
		echo "    Installing app ${APP}"
		cozy-stack apps install --domain "${DOMAIN}" "${APP}" 1>/dev/null
		coclyco regenerate "${DOMAIN}"
	fi
}

function uninstall_app {
	DOMAIN="${1}"
	APP="${2}"
	if app_installed "${@}"; then
		echo "    Uninstalling app ${APP}"
		cozy-stack apps uninstall --domain "${DOMAIN}" "${APP}" 1>/dev/null
	else
		echo "    App ${APP} already uninstalled, nothing to do"
	fi
}

echo "Migrating collect to home"
cozy-stack instances ls | awk '{print $1}' | while read domain; do
		echo "  Migrating ${domain}"
		install_app "${domain}" home
		uninstall_app "${domain}" collect
done
