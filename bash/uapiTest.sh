#!/bin/bash

json=$(curl -sku "jssadmin" https://manage.lab.private:8443/uapi/auth/tokens -X POST)
token=$(echo $json  | awk -F"," '{ print $1 }' | awk -F'"' '{ print $4 }')

cat /Users/Shared/buildings.json | while read building;do
	curl -k -X POST --header 'Content-Type: application/json' --header "Authorization: jamf-token $token" -d "$building" 'https://manage.lab.private:8443/uapi/settings/obj/building'
done

