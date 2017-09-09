# unpackaged-software-updates
Scripts to notify about and perform updates of unpacked software (mostly by scrapping download pages)

## Update checker
`./*/check-for-updates.sh` performs update checks for the software.
DO NOTE that the scripts check against thier last known version (saved as `./*/last_version.state`),
not what may be installed on your systems. Therefore you will get one notification when a new update is discovered;
there will not be constant nagging should you decide to not update.

`./run-update-checks.sh` runs update checks for all executable `./*/check-for-updates.sh`,
unless you create a `whitelist` file in the repo root. Then, it will only run whitelisted update checkers.
Whitelist update checkers by putting thier folder names in the `whitelist` file, one per line.


## Update scripts
*TODO*
