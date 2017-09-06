#!/bin/sh

# Echos arguments with date and script dir prefix
mylog() {
	echo "$(date +%F\ %T) [$(basename "$SCRIPT_DIR")] $@"
}

# Sends the update avilable mail
send_update_info_mail() {
	if [ -f "mailto" ]; then
		mailto="$(cat "mailto")"
	elif [ -f "../mailto" ]; then
		mailto="$(cat "../mailto")"
	else
		mylog "ERR: No mailto file found, cannot send mail!"
		exit 2
	fi
	
	mylog "Sending mail: '$@' to '$mailto'"
	mailx -r "Unpackaged Software Updates <$(id -un)>" -s "USU: $@" $mailto <<-EOF
		Hi!
		Looks like there is an Update: $@
	EOF
}

# Checks if the version has changed since the last run (and save the new version if so)
has_version_changed(){
	# Get the last version (if aviable)
	if [ -f "last_version.state" ]; then
		last_version=$(cat "last_version.state")
	else
		last_version=""
	fi

	if [ "$@" != "$last_version" ]; then
		mylog "Latest avilable version '$1' is different from last version '$last_version'..."
		echo "$1" > last_version.state
		return 0
	else
		mylog "Latest avilable version '$1' has not changed since last check..."
		return 1
	fi
}