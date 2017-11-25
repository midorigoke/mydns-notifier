#!/bin/bash

cd "$(dirname "$BASH_SOURCE")"

jq '.accounts[] as $account | (select($account.IPv4) | $account.id, $account.password, .endpoints.IPv4, "IPv4"), (select($account.IPv6) | $account.id, $account.password, .endpoints.IPv6, "IPv6")' settings.json |
xargs -L4 |
awk '{print "curl -sS -u "$1":"$2" "$3" | grep -F \"Login and IP address notify OK.\" >/dev/null || echo Notification Failed id:"$1" protocol:"$4}' |
sh
