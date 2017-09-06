#!/bin/sh
# ===== Seafile Server : print_current_ver_dllink.sh =====
# Prints current Seafile server version (line 1) and dllink (line 2).
# 	./print_current_ver_dllink.sh [ARCH]
# ARCH is optional and autodetected if not given,
# Possible values are listed in the comment before ARCH detection.

# Amazon S3 (?) Bucket URL (must have listing enabled, we 'parse' the list xml)
# Must not include trailing '/' for proper download url building.
SEADRIVE_URL="https://download.seadrive.org"

# ARCH is the arch in the file name: seafile-server_VERSION_ARCH.tar.gz
# Known values are: x86-64, i386, win32
# Autodetection works on linux for x86-64 and i386; it probabaly won't work for Windows
# (my MINGW64 Bash returns 'x86_64' for 'uname -m' on a 64bit Windows)
# Source (using kernel because lsb_release -s returns no modules on my debian 9):
# https://superuser.com/questions/208301/linux-command-to-return-number-of-bits-32-or-64/208306#208306
uname_m=$(uname -m)
if [ -n "$1" ]; then
	ARCH="$1"
elif [ "$uname_m" = "x86_64" ]; then
	ARCH="x86-64"
elif [ "$uname_m" = "i386" ] || [ "$uname_m" = "i486" ] || [ "$uname_m" = "i586" ] || [ "$uname_m" = "i686" ]; then
	ARCH="i386"
else
	echo "Unkown system arch: '$uname_m', cannot get download link"
	exit 1
fi

# get Amazon S3 Bucket listing XML (comes as one line)
# linebreak the string after every > (= replace every ">" with ">\n")
# grep for seafile server downloads (incl. closing xml tag!)
# remove the closing </Key> tag
# sort it so that the most recent version is the topmost
# eat everyting except the topmost line
latest=$(curl -s "$SEADRIVE_URL" | \
	sed "s/>/>\n/g" | \
	grep "^seafile-server_.*_$ARCH.tar.gz</Key>$" | \
	sed "s/<\/Key>$//" | \
	sort -h -r | \
	head -1)

echo "$latest" | sed "s/^seafile-server_//" | sed "s/_$ARCH.tar.gz$//"
echo "$SEADRIVE_URL/$latest"

# I think I toyed with daemons and other powerful forces here.
