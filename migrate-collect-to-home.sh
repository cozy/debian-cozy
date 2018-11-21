#!/usr/bin/env bash
echo "Migrating collect to home"
cozy-stack instances ls | awk '{print $1}' | while read domain; do
        echo "  Migrating ${domain}"
        cozy-stack apps show home --domain "${domain}" &>/dev/null
        if [ $? ]; then
                echo "    home already installed, nothing to do"
        else
                echo "    Installing home"                
                cozy-stack apps install home --domain "${domain}" 1>/dev/null
        fi

        cozy-stack apps show collect --domain "${domain}" &>/dev/null
        if [ ! $? ]; then
                echo "    Uninstalling collect"                
                cozy-stack apps uninstall collect --domain "${domain}" 1>/dev/null
        else
                echo "    collect not installed, nothing to do"
        fi
done
