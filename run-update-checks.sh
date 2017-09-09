#!/bin/sh
# Run all whitelisted update checks if 'whitelist' exists in the script direcotry, 
# otherwise run all update checks
# how to whitelist: one foldername per line in $SCRIPT_DIR/whitelist

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
cd "$SCRIPT_DIR"

for file in ./*/check-for-updates.sh ; do
        if [ -f whitelist ]; then
                if grep -q $(basename $(dirname "$file")) whitelist ; then
                        [ -x  "$file" ] && "$file"
                fi
        else
                [ -x  "$file" ] && "$file"
        fi
done
