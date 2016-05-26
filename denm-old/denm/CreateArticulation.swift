
/**
Articulation Factory

- staccato
- staccatissimo
- martellato
- tenuto
- accent
- compound articulations: tenuto/staccato, tenuto/accent, etc
- trill
- tremolo
- mordent
- mordent inverted
- turn
- double- / triple-tongueing
- perhaps more contemporary techniques (jete, etc)
- ! NO SLUR HERE, that is its own beast
*/
class CreateArticulation {
    
    /**
    Create Articulation with ID
    
    :param: ID String representation of Articulation
    
    :returns: Articulation?
    */
    func withID(ID: String) -> Articulation? {
        if ID == "." { return ArticulationStaccato() }
        if ID == "-" { return ArticulationTenuto() }
        if ID == ">" { return ArticulationAttack() }
        if ID == ">." { return ArticulationAttackStaccato() }
        if ID == ".>" { return ArticulationAttackStaccato() }
        if ID == ">-" { return ArticulationAttackTenuto() }
        if ID == "->" { return ArticulationAttackTenuto() }
        if ID == ".-" { return ArticulationTenutoStaccato() }
        if ID == "-." { return ArticulationTenutoStaccato() }
        return nil
    }
}