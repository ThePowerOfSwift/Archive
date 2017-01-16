#!/bin/sh

#  readme-update.sh
#  
#
#  Created by Jeremy Corren on 10/27/16.
#

> README.md

framework="# $1"

cat <<EOT>> README.md
$framework

![Swift](https://img.shields.io/badge/%20in-swift%203.0-orange.svg) [![Build Status](https://travis-ci.org/dn-m/$1.svg?branch=master)](https://travis-ci.org/dn-m/$1) [![codecov](https://codecov.io/gh/dn-m/$1/branch/master/graph/badge.svg)](https://codecov.io/gh/dn-m/$1/) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![GitHub version](https://badge.fury.io/gh/dn-m%2F$1.svg)](https://badge.fury.io/gh/dn-m%2F$1)

<a name="integration"></a>
## Integration

### Carthage
Integrate **$1** into your OSX or iOS project with [Carthage](https://github.com/Carthage/Carthage).

1. Follow [these instructions](https://github.com/Carthage/Carthage#installing-carthage) to install Carthage, if necessary.
2. Add \`github "dn-m/$1"\` to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile).
3. Follow [these instructions](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) to integrate **$1** into your OSX or iOS project.

***

### Documentation

See the [documentation](http://dn-m.github.io/$1/).
EOT
