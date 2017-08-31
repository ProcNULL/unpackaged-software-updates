#!/usr/bin/env python3
# ts3srv_get_current_ver_dllink.py version 2017-08-25
# Gets and prints current TS3 server version and download links for the selected architecture.
# CMD-LINE ARGS: <script> [PLATFORM [ARCH]]
#	PLATFORM defaults to 'linux', for other options see comment before DLLINK_PLATFORM
#	ARCH defaults to '64-bit', for other options see comment before DLLINK_ARCH
# DEPENDS ON: requests (Debian 9: python3-requests), BeautifulSoup4 (Debian 9: python3-bs4)
# OUTPUT: on first line the current version as avilable on the download page,
#	on consecutive lines the download links for your platform/arch

#TODO: Print checksum

import sys
import requests
from bs4 import BeautifulSoup

TS3_DOWNLOAD_URL = "http://teamspeak.com/en/downloads.html"

# Which platform you want the download link extracted for:
# 	windows, linux, macos, freebsd
# (This is the css class (in addition to 'platform') of the platform block divs)
DLLINK_PLATFORM = "linux" if len(sys.argv) < 2 else sys.argv[1]

# Which arch do you want the download link extracted for:
#	64-bit, 32-bit, Universal Binary (only for macos platform)
# (This is the text after 'Server' in the downloads list)
DLLINK_ARCH = "64-bit" if len(sys.argv) < 3 else sys.argv[2]

response = requests.get(TS3_DOWNLOAD_URL)
soup = BeautifulSoup(response.content, "html.parser")

servertab = soup.find(id="tab-server")
platform_div = servertab.find("div", class_="platform " + DLLINK_PLATFORM)

if platform_div is not None:
	ver_spans = platform_div.find_all("span", class_="version")

	for span in ver_spans:
		if "Server " + DLLINK_ARCH in span.previous:
			result_version = span.get_text(strip=True)
			
			row = span.parent.parent.parent
			options = row.find("select", class_="mirror form-control").find_all("option")
			
			result_dllinks = {}
			for e in row.find("select", class_="mirror form-control").find_all("option"):
				result_dllinks[e.get_text(strip=True)] = e["value"]
			
			break

# We found something...
if "result_version" in locals():	
	print(result_version)
	for host in result_dllinks: print(result_dllinks[host])
