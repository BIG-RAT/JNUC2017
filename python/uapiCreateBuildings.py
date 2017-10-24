#!/usr/bin/python

import base64
import getpass
import json
import ssl
import urllib2


def main():
##	URL to the Universal API (uapi)	
	baseUrl = 'https://manage.lab.private:8443/uapi'
	
##	File holding list of buildings (JSON formatted)
	buildingFile = '/Users/Shared/buildings.txt'
	
##	to trust self signed certs, include the following line
	ssl._create_default_https_context = ssl._create_unverified_context
	
##	uapi URL to request token	
	tokenUrl = baseUrl + '/auth/tokens'
	userName = raw_input("Enter Jamf Server username: ").strip()
	userPass = getpass.getpass(prompt="Enter Jamf Server password: ").strip()
	base64Creds = base64.b64encode('%s:%s' % (userName,userPass))
	
	tokenRequest = urllib2.Request(tokenUrl)
	tokenRequest.add_header("Authorization", "Basic %s" % base64Creds)
	tokenRequest.add_header("Accept", "application/json")
	tokenRequest.add_header("ContentType", "application/json")
	
	result = urllib2.urlopen(tokenRequest, '')
	data = result.read()

	jsonData = json.loads(data)
	token = jsonData['token']
	
	buildingUrl = baseUrl + '/settings/obj/building'
	newBuilding = urllib2.Request(buildingUrl)
	newBuilding.add_header("Authorization", "jamf-token %s" % token)
	newBuilding.add_header("Accept", "application/json")
	newBuilding.add_header("Content-Type", "application/json")
	with open (buildingFile, "r") as myfile:
		for line in myfile:
			building = line.strip()
			result = urllib2.urlopen(newBuilding, building)
			

if __name__ == "__main__":
	main()