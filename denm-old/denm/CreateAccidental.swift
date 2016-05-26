/**
Accidental Factory
*/
class CreateAccidental {
    
    /**
    Create an Accidental with coarse value and fine value of PitchSpelling
    
    :param: coarse Coarse value of PitchSpelling (Sharp, QuarterFlat, Natural, etc)s
    :param: fine   Fine value of PitchSelling (Up, Down)
    
    :returns: Accidental?
    */
    func withCoarse(coarse: Float, fine: Float) -> Accidental? {
        if coarse == +0.0  && fine == 0        { return AccidentalNatural()! }
        if coarse == +0.0  && fine == 0.25     { return AccidentalNaturalUp()! }
        if coarse == +0.0  && fine == -0.25    { return AccidentalNaturalDown()! }
        if coarse == +0.5  && fine == 0        { return AccidentalQuarterSharp()! }
        if coarse == +0.5  && fine == 0.25     { return AccidentalQuarterSharpUp()! }
        if coarse == +0.5  && fine == -0.25    { return AccidentalQuarterSharpDown()! }
        if coarse == +1.0  && fine == 0        { return AccidentalSharp()! }
        if coarse == +1.0  && fine == 0.25     { return AccidentalSharpUp()! }
        if coarse == +1.0  && fine == -0.25    { return AccidentalSharpDown()! }
        if coarse == -0.5  && fine == 0        { return AccidentalQuarterFlat()! }
        if coarse == -0.5  && fine == 0.25     { return AccidentalQuarterFlatUp()! }
        if coarse == -0.5  && fine == -0.25    { return AccidentalQuarterFlatDown()! }
        if coarse == -1.0  && fine == 0        { return AccidentalFlat()! }
        if coarse == -1.0  && fine == 0.25     { return AccidentalFlatUp()! }
        if coarse == -1.0  && fine == -0.25    { return AccidentalFlatDown()! }
        return nil
    }
}