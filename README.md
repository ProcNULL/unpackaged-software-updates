# unpackaged-software-updates
Scripts to notify about and perform updates of unpacked software (mostly by scrapping download pages)

## Update checker
`./*/check-for-updates.sh` performs update checks for the software.
DO NOTE that the scripts check against the last known version (saved as `./*/last_version.state`),
not what may be installed on your systems. Therefore you will get one notification when a new update is discovered;
there will not be constant nagging should you decide not to update.

`./run-update-checks.sh` runs update checks for all executable `./*/check-for-updates.sh`,
unless you create a `whitelist` file in the repo root. Then, it will only run whitelisted update checkers.
Whitelist update checkers by putting thier folder names in the `whitelist` file, one per line.

#### Configuration
The `./whitelist` file as noted above.

Configure who gets informed about updates by placing a mailto file in either the repo root (fallback),
or the individual folders. If there is no mailto file in a specific folder, the fallback will be used.
`cat mailto` if fed to mailx as "To", so make sure whatever you put in this file makes mailx happy.


## Update scripts
*TODO*
