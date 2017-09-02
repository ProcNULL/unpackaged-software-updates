#!/bin/sh
# ===== Seafile Server =====
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
cd "$SCRIPT_DIR"
. "$SCRIPT_DIR/../usulib.sh"

SEADRIVE_URL="https://download.seadrive.org/"

# What this thing below does:
# get Amazon S3 Bucket listing XML (comes as one line)
# linebreak the string after every > (= replace every ">" with ">\n")
# grep for seafile server downloads (incl. closing xml tag!)
# remove the stuff that comes before and after the version number
# sort it so that the most recent version is the topmost
# eat everyting except the topmost line
online_version=$(curl -s "$SEADRIVE_URL" | \
	sed "s/>/>\n/g" | \
	grep "^seafile-server_.*_x86-64.tar.gz</Key>$" | \
	sed "s/^seafile-server_//" | sed "s/_x86-64.tar.gz<\/Key>$//" | \
	sort -h -r | \
	head -1)

if has_version_changed "$online_version"; then
	send_update_info_mail "Seafile Server $online_version"
fi

# I think I toyed with daemons and other powerful forces here.
