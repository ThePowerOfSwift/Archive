class CreateStem {
    func withType(type: String) -> Stem? {
        if type == "ord" { return Stem() }
        if type == "rest" { return StemRest() }
        return nil
    }
}