#!/bin/sh
# ===== TS3 Server : check-for-updates.sh =====
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
cd "$SCRIPT_DIR"
. "$SCRIPT_DIR/../usulib.sh"

mylog "Checking for updates..."

# Workaround/Hack: Check if OS is Msys (Windows) and if not use 'py -3' instead
# (this was developed on a windows machine that only has the 'py' launcher in %PATH%)
PYTHONBIN="python3"
if [ $(uname -o) = "Msys" ]; then
	mylog "INFO Using 'py -3' instead of 'python3' because we probably run on MSYS"
	PYTHONBIN="py -3";
fi

result=$($PYTHONBIN print_current_ver_dllink.py); exitcode=$?
if [ "$exitcode" -ne "0" ]; then
	echo "ERR Failed to fetch current TS3 Server version: Python Skript exited with $exitcode"
	echo "  Are the dependencies (see comment in print_current_ver_dllink.py) installed?"
	echo "  '$PYTHONBIN print_current_ver_dllink.py' Ouptut (not indented):"
	echo "$result"
	exit 1
fi

# Extract online version from script output
version=$(echo "$result" | head -1)

if has_version_changed "$version"; then
	send_update_info_mail "Teamspeak 3 Server $version"
fi
