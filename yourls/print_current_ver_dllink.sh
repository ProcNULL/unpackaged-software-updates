#!/bin/sh
# ===== YOURLS : print_current_ver_dllink.sh =====
# Prints current YOURLS version (line 1) and dllink (line 2).

# YOURLS API Endpoint. Must return "pretty" JSON
VERSION_API="https://api.yourls.org/core/version/1.0/"

json=$(curl -s "$VERSION_API")
latest=$(echo "$json" | grep "^    \"latest\": \".*\",$" | \
	sed "s/^    \"latest\": \"//" | sed "s/\",$//" )
dllink=$(echo "$json" | grep "^    \"zipurl\": \".*\"$" | \
	sed "s/^    \"zipurl\": \"//" | sed "s/\"$//"  | \
	sed "s/\\\\\//\//g" )
#   ^ replace \/ by /

echo "$latest"
echo "$dllink"
