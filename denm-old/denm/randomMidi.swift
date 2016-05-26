import QuartzCore

func randomMidi() -> Float {
    let midi = Float(arc4random_uniform(120))/4.0 + 58.0
    return midi
}