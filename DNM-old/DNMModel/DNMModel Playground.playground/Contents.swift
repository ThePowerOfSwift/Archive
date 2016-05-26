import UIKit
import DNMModel
//: # DNMModel walkthrough

//: Create a Beats value
let b = Beats(amount: 2)

//: Create a Subdivision value
let s = Subdivision(value: 32)

//: Create a Duration
let d = Duration(beats: b, subdivision: s)

//: Create a DurationNode


let event1 = DurationNode(floatValue: 0.75)
let event2 = DurationNode(floatValue: 1.5)

let rhythm  = DurationNode()
rhythm.addChild(event1)
rhtyhm.addChild(event2)















