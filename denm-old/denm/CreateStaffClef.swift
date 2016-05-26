/**
Staff Clef Factory
*/
class CreateStaffClef {
    
    /**
    Create StaffClef with type and transposition
    
    :param: type          Type of StaffClef
    :param: transposition Transposition of StaffCleff
    
    :returns: Self: StaffCleff
    */
    func withType(type: String, transposition: Int) -> StaffClef? {
        var clef: StaffClef?
        if type == "treble" { clef = ClefTreble()! }
        else if type == "alto" { clef = ClefAlto()! }
        else if type == "tenor" { clef = ClefTenor()! }
        else if type == "empty" { clef = ClefEmpty()! }
        else if type == "bass" { clef = ClefBass()! }
        if clef != nil { clef!.setTransposition(transposition); return clef }
        else { return nil }
    }
}