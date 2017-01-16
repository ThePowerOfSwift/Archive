# FrameworkTools
Tools for generating and manipulating cross-platform (iOS + OSX) Swift frameworks

## Requires
- [Carthage](https://github.com/Carthage/Carthage) for managing Swift dependencies
- [Bundler](http://bundler.io/) for managing Ruby dependencies

## Installation
- Use [Carthage](https://github.com/Carthage/Carthage) to manage dependencies
- Add `github dn-m/FrameworkTools` to Cartfile
- Run the following from the command line:

```Bash
carthage bootstrap
bundle install --gemfile Carthage/Build/Mac/FrameworkTools.framework/Resources/Gemfile
cp Carthage/Build/Mac/FrameworkTools.framework/Resources/framework /usr/local/bin
sudo cp -r Carthage/Build/Mac/*.framework /Library/Frameworks/
```

That this requires `sudo` is unfortunate, and is hopefully temporary. When a Swift script file determines its framework search paths (which could ordinarily be set by `-F Carthage/Build/Mac`, if it weren't used as a more global tool), it uses the relative path given according to where the call is made at the command line, not where the file is saved.

Further, much of the heavy lifting for under-the-hood Xcode configuration is done by calling the [Cocoapods/Xcodeproj](https://github.com/CocoaPods/Xcodeproj) API, which is in Ruby. There is a desire to accomplish this only with Swift, however. In the future, the [Swift Package Manager](https://github.com/apple/swift-package-manager) will possibly cover many of these processes anyway.

For future reading:
- [Xcode projects](http://www.mokacoding.com/blog/xcode-projects-and-workspaces/) (for just writing the PBXProjects directly)
- [Xcconfigs](https://github.com/jspahrsummers/xcconfigs)
