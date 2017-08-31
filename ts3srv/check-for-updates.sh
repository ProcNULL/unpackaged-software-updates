#!/bin/sh
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
cd "$SCRIPT_DIR"
. "$SCRIPT_DIR/../usulib.sh"

result=$(python3 print_current_ver_dllink.py); exitcode=$?
if [ "$exitcode" -ne "0" ]; then
	echo "ERR Failed to fetch current TS3 Server version: Python Skript exited with $exitcode"
	echo "  Are the dependencies (see comment in print_current_ver_dllink.py) installed?"
	echo "  'python3 print_current_ver_dllink.py' Ouptut (not indented):"
	echo "$result"
	exit 1
fi

# Extract online version from script output
online_version=$(echo "$result" | head -1)

if has_version_changed "$online_version"; then
	send_update_info_mail "Teamspeak 3 Server $online_version"
fi

