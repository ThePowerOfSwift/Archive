# 300-19
Repository for Independent Study 300-19: Organization of DNM

See the work-in-progress [documentation](http://dn-m.github.io/) of this project.

***

#### Table of Contents

1. **[Background](#background)**
  - [What is Swift?](#swift)
  - [Getting started with Swift](#getting_started)  
  - [Swift and Audio](#swift_audio)

2. **[Course Objectives](#objectives)**
  - [x] [Use Carthage to manage frameworks](#carthage)
  - [x] [Make frameworks cross-platform](#cross-platform)
  - [x] [Refine granularity of frameworks](#frameworks-granularity)
  - [x] [Ensure Travis CI tests all frameworks for appropriate platform(s)](#travis_ci)
  - [x] [Generate documentation using jazzy](#jazzy)
  - [ ] [Add testing for graphical rendering framework(s)](#graphics-tests)

***

<a id="background"></a>
## Background

<a id="swift"></a>
### What is Swift?
- [About Swift (Apple)](https://swift.org/about/) 
- [Swift Tour (Apple)](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html)
- [Swift documentation (Apple)](https://swift.org/documentation/)
- [Swift Language iBook (link to ePub)](https://swift.org/documentation/TheSwiftProgrammingLanguage(Swift2.2).epub)

***

<a id="getting_started"></a>
### Getting Started with Swift
- Download [Xcode (download page)](https://developer.apple.com/xcode/) -- get latest version to use most up-to-date Swift lang, and...
- Download this [Guided Tour Playground (.zip)](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.playground.zip), or...
- Open Xcode, and create a new Playground via `File -> New -> Playground...`

***

<a id="swift_audio"></a>
### Swift and Audio

#### Texts
- **Audio API Overview**: [objc.io (article)](https://www.objc.io/issues/24-audio/audio-api-overview/)
  - Overview of the Audio APIs in the Apple ecosystem (mostly Objective-C wrappers for C APIs)
- **Functional Signal Processing Using Swift**: [objc.io (article)](https://www.objc.io/issues/24-audio/functional-signal-processing/), [GitHub (repo)](https://github.com/liscio/FunctionalDSP)
  - Application of Functional Programming for use in low-level Signal Processing (as implemented in [Faust](http://faust.grame.fr))
- **Audio Processing Dog House**: [objc.io (article)](https://www.objc.io/issues/24-audio/audio-dog-house/)
  - Really nicely designed, interactive demonstration of basic low-level DSP, with an example or two in Swift
- **Learning Core Audio with Swift 2.0** (Ales Tsurko): [Github (repo)](https://github.com/AlesTsurko/LearningCoreAudioWithSwift2.0)
  - [Learning Core Audio (link to Amazon: book)](http://www.amazon.com/Learning-Core-Audio-Hands-On-Programming/dp/0321636848) (Objective-C) examples rewritten in Swift
- **Swift and Core Audio**: [article](http://www.rockhoppertech.com/blog/swift-and-core-audio/), [Github (repo)](https://github.com/genedelisa/SwiftSimpleGraph)
- **AVFoundation to play audio or MIDI**: [article](http://www.rockhoppertech.com/blog/swift-2-avfoundation-to-play-audio-or-midi/), [Github audio (repo)](https://github.com/genedelisa/AVFoundationPlay), [Github midi (repo)](https://github.com/genedelisa/AVFoundationMIDIPlay)
- **Swift 2.0 and CoreMidi**: [article](http://www.rockhoppertech.com/blog/swift-2-and-coremidi/), [Github (repo)](https://github.com/genedelisa/Swift2MIDI)
- [Surge](https://github.com/mattt/Surge) may be useful for using Accelerate APIs (often used for DSP) in Swift
- [This](https://www.youtube.com/watch?v=-ag-f9N8SJE&index=5&list=PLAVm70iJlMusekZaxufRPS4OjNOs7L7zi) is a nice presentation about using C apis in Swift, by Chris Eidhof.
 
#### Video tutorials
- **Swift 2.0 Audio** (AVFoundation, AVAudioPlayer, NSURL, NSBundle): [Youtube](https://www.youtube.com/watch?v=RKfe7xzHEZk)
- **Using Audio: Swift**: [Youtube](https://www.youtube.com/watch?v=Kq7eVJ6RSp8)
- **Recording Audio: Swift**: [Youtube](https://www.youtube.com/watch?v=4qj1piMAPE0)

#### Frameworks
- **AudioKit**: [GitHub (repo)](https://github.com/audiokit/AudioKit), [Website](http://audiokit.io)
  - Swift-friendly open-source audio synthesis, processing, & analysis platform

***
***

<a id="objectives"></a>
## Course Objectives

<a id="frameworks-granularity"></a>
### Refine Granularity of Frameworks
The current organization of the frameworks (which can be seen [here](https://github.com/jsbean/DNM)) that comprise DNM is:
- **DNM_iOS** (iOS app)
- **DNM Text Editor** (OSX app)
- **DNMModel** (cross-platform framework, with objects modeling musical constructs)
  - Used by DNM_iOS and DNM Text Editor

For a variety of reasons, this organization is not optimal. DNM is a relatively complex project, with many subsystems that must be treated as such. Currently, many subsystems are clumped together in coarse grains. I propose to isolate these components into finer grains. 

That being said, there are advantages and disandvantages to having a finer granularity of subsystems.

**The Good**:
- Ability to extract code for reuse in other projects
- Clarity of organization and intent
- Faster compile times

**The Bad**:
- [Dependency Hell](https://en.wikipedia.org/wiki/Dependency_hell)
- Greater complexity dealing with cross-platform targets

#### In Context

For example, DNMModel should only contain structures that model musical constructs in abstract form. It currently contains low-level utility functions and extensions of Swift standard library types that are not specific to DNM. These utilities should be moved to their own framework, called DNMUtility.

DNMModel also contains the code for a Parser that converts text input into a ScoreModel (the objects comprising a musical score). The Parser is itself a complex structure, that requires DNMModel, but is not required by DNMModel. As such, it should be extracted from DNMModel and moved to their own framework, called DNMParser. Further, as conversions from other formats (MIDI, MusicXML, etc.) are implemented, they should each exist within their own framework, which holds DNMModel as a dependency.

Even worse, DNMModel contains a file `SwiftyJSON.swift`, which is the source code for an external framework that manages JSON files in a natively-Swift manner. While DNMModel uses this, this is cluttering its intent, while disabling any possibility of updating the `SwiftyJSON` framework as it is developed.

#### Not for lack of trying...

There is a reason, however, why this bloating exists within the organization of DNM. Creating frameworks that work on both iOS and OSX platforms is not trivial. I was successful (to a certain degree) doing so with DNMModel, though I wasn't successful doing so for an arbitrarily nested hierarchy of frameworks (which is necessary for the [proposed organization](#proposed-organization)).  I have made previous attempts in the past to construct a finer-grained organization of DNM, though each time I reverted back to the more clunky version in defeat.

The current, bloated construction makes for slower compile times. And while it reduces the amount of frameworks (and therefore dependencies between which to manage), the monolithic nature of the codebase feels even less inviting.

<a id="proposed-organization"></a>
### Proposed organization of target applications and frameworks

#### Target Applications
- DNM iOS app (for iPads)
- DNM OS X Text Editor (for desktop)

#### Frameworks
- **DNMUtility**
  - Platforms: iOS + OSX
  - Discussion: Can be broken into finer grains
    - Actually, a general Utility framework seems to be bad form
- **DNMModel**
  - Discussion: Can be broken into finer grains
  - Platforms: iOS + OSX
  - Dependencies:
    - DNMUtility
- **DNMParser**
  - Discussion: Currently embedded in DNMModel  
  - Platforms: iOS + OSX
  - Dependencies:
    - DNMUtility
    - DNMModel
- **DNMRenderer**
  - Discussion: 
    - Currently embedded in iOS target application
    - Can be broken into finer grains
  - Platforms: Currently iOS only, considerable refactoring needed for OSX support
  - Dependencies:
    - DNMUtility
    - DNMModel
- **DNMUI**
  - Discussion: Currently embedded in iOS target application
  - Platforms: iOS only (a separate UI framework would be created for OSX if necessary)

![dn-m Organization](https://github.com/dn-m/300-19/blob/master/img/dn-m_organization.png)

[Here](https://www.youtube.com/watch?v=lqNUTW0F4bw) is a nice presentation arguing to finer-grained libraries.

### Investigate and embrace third-party frameworks:
  - [SwiftCheck](https://github.com/typelift/SwiftCheck)
  - [Result](https://github.com/antitypical/Result)
  - [Operadics](https://github.com/typelift/Operadics/tree/c65e6355e22282a89d68a8a2d594a32c36c1e7b0)
  - [Swiftz](https://github.com/typelift/Swiftz)
  - [Async](https://github.com/duemunk/Async)
  
***

<a id="cross-platform"></a>
### Make Frameworks Cross-platform

See: [this](http://colemancda.github.io/programming/2015/02/11/universal-ios-osx-framework/), and [this](https://acolangelo.com/blog/cross-platform-frameworks-in-xcode), and [this](https://developer.apple.com/videos/play/wwdc2014-233/).

Check out configuring [xccongfigs](https://github.com/mrackwitz/xcconfigs).

Check out [notes](https://github.com/dn-m/300-19/blob/master/Notes/CrossPlatformFrameworkNotes.md) for making cross-platform frameworks.

***

<a id="graphics-tests"></a>
### Add Tests for Graphics Framework(s)
Currently, the DNMModel framework is relatively well-tested (though more work needs to be done). However, the graphics rendering aspects are completely untested. This also includes a large amount of drawing logic that doesn't require special tools to be tested, but for the reasons of dirtiness of cross-platform frameworks communication a test suite has not yet been implemented.

Injecting a test-driven development model into graphics implementation will improve this development process significantly.

[FBSnapshotTestCase](https://github.com/facebook/ios-snapshot-test-case) creates an image from graphical objects for reference, and tests pixel-by-pixel equality between this reference image, and a new image created every time tests are run.

Look into [Kaleidoscope](http://www.kaleidoscopeapp.com), which will show diffs in images (e.g., generated from FBSnapshotTestCase).

***

<a id="travis_ci"></a>
###Ensure Travis CI Tests All Frameworks for Appropriate Platform(s)
[Travis-CI](https://travis-ci.com) is a continuous integration service that builds and runs all tests against given code -- every time a commit is made on GitHub.

Currently, only DNMModel is set up to be tested in Travis CI. This service should be applied to all frameworks.

See examples like [this](https://github.com/ReSwift/ReSwift/blob/master/.travis.yml) of more complex `.travis.yml` set-ups.

***

<a id="carthage"></a>
### Use Carthage to Manage Frameworks
[Carthage](https://github.com/Carthage/Carthage) is a Swift dynamic framework dependency manager. Check out this [presentation](https://realm.io/news/swift-dependency-management-with-carthage/) on what Carthage is and does by its lead developer.

#### Notes for Carthage usage
Place `Cartfile` directly in the folder containing the .xcodeproj of a framework or application, e.g.:
```Swift
FrameworkOrApplicationDirectory
FrameworkOrApplication.xcodeproj
Cartfile // put Cartfile here
Cartfile.resolved // created by Carthage upon: carthage update
Carthage // create by Carthage upon: carthage update
```

While Carthage resolves and builds all (sub)dependencies, all dependencies need to be added to the current project (Framework or Application target).

Also consider [Swift Package Manager](https://swift.org/package-manager/). SPM is early in development, and looks like it only supports OSX and Linux, but this may be the best long-term solution.

***

<a id="jazzy"></a>
### Generate Documentation Using Jazzy
[jazzy](https://github.com/realm/jazzy) automatically generates documentation (in the form of HTML / CSS) from specially-formatted comments in a Swift codebase. 

See [this](http://jamesbean.info/denm/docs/index.html), which is a (very) outdated example from the DNM project.

Ultimately, build a single website, with links to a jazzy-generated sub-site for each framework:
```
Main
+– DNMUtility
+– DNMModel
+– DNMParser
+– DNMRenderer
+– DNMUI
```

See [this](https://github.com/audiokit/AudioKit/blob/master/AudioKit/.jazzy.yaml) as an example of a custom `jazzy.yml` file, which generates [this](http://audiokit.io/docs/).
***

## Reading

### Design:
- Design Patterns: Eric Gamma, et al
- Pattern Hatching: Vlissides, John
- Refactoring: Fowler, Martin
- Analysis Patterns: Fowler, Martin
- Clean Code: Martin, Robert
- Code Complete: McConnell, Steve
- Pragmatic Programmer: Hunt, Andrew

### Testing:
- Test-Driven Development by Example: Beck, Kent

### Swift:
- Functional Programming in Swift: Eidhof, Chris; Kugler, Florian; Swierstra, Wouter
- Advanced Swift: Eidof, Chris

### Parser:
- Compilers: Principles, Techniques, and Tools: Aho, Alfred V.

### Other reference:
- C programming language: K & R
- Bash cookbook: Albing, Carl
- Classic shell scripting: Robbins, Arnold

