# ScriptingTools
Tools for scripting in Swift

### Usage

#### Use [Carthage](https://github.com/Carthage/Carthage) for dependency management
- Add `github "dn-m/ScriptingTools"` to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile)
- Run `carthage bootstrap`

#### Create a Swift file

- Add the following at the top of the new Swift file

```Swift
#!/usr/bin/swift -F Carthage/Build/Mac

import ScriptingTools
```
- Make Swift file executable (e.g., `chmod +x script.swift`)
- Add some Swift code (e.g., `print("oh, hi there!")`)
- Run the Swift script (e.g., `./script.swift // => oh, hi there!`)

### Dependencies
- [SwiftShell](https://github.com/kareman/SwiftShell)

### Research

- Excellent repo about [Swift-Scripts](https://github.com/blakemerryman/Swift-Scripts)
- Repo for [Shell Scripting in Swift](https://github.com/kareman/SwiftShell)
- Nice video about [Swift Scripting](https://realm.io/news/swift-scripting/)
- Repo for [Command Line Utility composer for Swift](https://github.com/kylef/Commander)
- Nice presentation about [CLIs in Swift](https://speakerdeck.com/supermarin/swift-for-cli-tools)
- Blog post about [Scripting in Swift](http://krakendev.io/blog/scripting-in-swift)
- [SwiftRuby](https://github.com/RubyNative/SwiftRuby)
- [Diamond](https://github.com/RubyNative/Diamond)
- [Scripting in Swift](https://www.shinobicontrols.com/blog/scripting-in-swift)
