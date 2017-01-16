#!/bin/sh

#  gitignore-update.sh
#  
#
#  Created by Jeremy Corren on 10/27/16.
#

> .gitignore

cat <<EOT>> .gitignore
## Build generated
build/
DerivedData/

## Various settings
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3
xcuserdata/

## Other
*.moved-aside
*.xcuserstate

## Obj-C/Swift specific
*.hmap
*.ipa
*.dSYM.zip
*.dSYM

# Carthage
Carthage/Checkouts
Carthage/Build
EOT
