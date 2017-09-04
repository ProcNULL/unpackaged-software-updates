#!/bin/sh
# ===== Seafile Server : check-for-updates.sh =====
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
cd "$SCRIPT_DIR"
. "$SCRIPT_DIR/../usulib.sh"

mylog "Checking for updates..."

result=$(./print_current_ver_dllink.sh); exitcode=$?
if [ "$exitcode" -ne "0" ]; then
	echo "ERR Failed to fetch current Seafile Server version: Skript exited with $exitcode"
	echo "  './print_current_ver_dllink.sh' Ouptut (not indented):"
	echo "$result"
	exit 1
fi

# Extract online version from script output
version=$(echo "$result" | head -1)

if has_version_changed "$version"; then
	send_update_info_mail "Seafile Server $version"
fi
