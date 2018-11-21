#!/usr/bin/env bash
echo "Migrating collect to home"
cozy-stack instances ls | awk '{print $1}' | while read domain; do
        echo "  Migrating ${domain}"
        apps_list=$(cozy-stack apps ls --domain "${domain}")
        app_installed=$(echo "${apps_list}" | grep "home")
        if [ -n "${app_installed}" ]; then
                echo "    home already installed, nothing to do"
        else
                echo "    Installing home"
                cozy-stack apps install home --domain "${domain}" 1>/dev/null
        fi

        app_installed=$(echo "${apps_list}" | grep "collect")
        if [ -n "${app_installed}" ]; then
                echo "    Uninstalling collect"
                cozy-stack apps uninstall collect --domain "${domain}" 1>/dev/null
        else
                echo "    collect not installed, nothing to do"
        fi
done
