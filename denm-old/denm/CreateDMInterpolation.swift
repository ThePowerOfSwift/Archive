/**
Dynamic Marking Interpolations Factory:

- Hairpin (cresc., decresc.; linear, or with exponent)
- Swell (convex, concave; linear or with exponent)
- Static
*/
class CreateDMInterpolation {
    func withID(ID: String) -> DMInterpolation? {
        if ID == "static" { return DMIStatic?() }
        if ID == "hairpin" { return DMIHairpin?() }
        if ID == "swell" { return DMISwell?() }
        return nil
    }
}