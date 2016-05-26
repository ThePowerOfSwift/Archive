/**
DMCharacter (Dynamic Marking Character) factory
*/
class CreateDMCharacter {
    
    /**
    Create DMCharacter with ID
    
    :param: ID String representation of DMCharacter
    
    :returns: DMCharacter?
    */
    func withID(ID: String) -> DMCharacter? {
        if ID == "f" { return DMCharacter_f()! }
        if ID == "p" { return DMCharacter_p()! }
        if ID == "m" { return DMCharacter_m()! }
        if ID == "o" { return DMCharacter_o()! }
        if ID == "!" { return DMCharacter_exclamation()! }
        if ID == "(" { return DMCharacter_parenLeft()! }
        if ID == ")" { return DMCharacter_parenRight()! }
        return nil
    }
}