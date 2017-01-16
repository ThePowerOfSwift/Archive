# Cross-platform frameworks for iOS / OS X

## Get started with first target
- Create new project
- Select `Cocoa Framework` with name: `{FRAMEWORKNAME}`
- Ensure `Include Unit Tests` is selected
- Delete all but attribute comments in `{FRAMEWORKNAME}.h`
- Move `{FRAMEWORKNAME}.h` in left pane to `{FRAMEWORKNAME}` project group (out of `{FRAMEWORKNAME}` subgroup)
- Ensure `{FRAMEWORKNAME} -> Build Phases -> Headers -> Public` contains `{FRAMEWORKNAME}.h`
  - Not `...Project`
- Switch `Build Settings -> Embedded Content Contains Swift` to `Yes`

## Add second target
- Select `Cocoa Touch Framework` with name: `{FRAMEWORKNAME}Mac`
- Delete groups for `{FRAMEWORKNAME}Mac`
- Delete folders in directory for `{FRAMEWORKNAME}Mac`

## Get second target up to speed with first
- Add `{FRAMEWORKNAME}Mac` as target of `{FRAMEWORKNAME}.h`
- Change `Build Settings -> Product Name: {FRAMEWORKNAME}`
- Change `Build Settings -> Info.plist File` to `{FRAMEWORKNAME}/Info.plist`

## Configure Test Targets
- **Add Copy Files Phase** for test targets (`{FRAMEWORKNAME}Tests} and {FRAMEWORKNAME}Mac.tests}`)
  - Create new `Copy Files Phase`
  - Select appropriate `{FRAMEWORKNAME}` product
- Change `Build Settings -> Info.plist File` to `{FRAMEWORKNAME}Tests/Info.plist`
- Drag **all** Frameworks to appropriate test target's `Link Binary with Binaries`

## Ensure both schemes are shared

## Add other frameworks, if necessary
### Using [Carthage](https://github.com/Carthage/Carthage)
- Create [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile)
- Run `carthage update`
- Create `Frameworks` group
- Create `iOS` and `Mac` groups within `Frameworks` group
- For target of each platform:
  - `General -> Linked Frameworks and Libraries -> + -> Add other...`
  - Select `{FRAMEWORKNAME}/Carthage/Build/{Mac/iOS}/{EMBEDDEDFRAMEWORKNAME}`
  - In `Build Phases`, add `New Run Script Phase`:
    - `/usr/local/bin/carthage copy-frameworks`
    - `$(SRCROOT)/Carthage/Build/{iOS/Mac}/FRAMEWORKNAME.framework`
- For each test target:
  - `Build Settings -> Runpath Search Paths` add `$(PROJECT_DIR)/Carthage/Build/{iOS/Mac}`

## Add tag
- `git tag v0.1`
- `git push origin tag v0.1`
