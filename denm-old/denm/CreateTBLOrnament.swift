/**
TBLOrnament (Tuplet Bracket Ligature Ornament) Factory
*/
class CreateTBLOrnament {
	
    /**
    Create TBLOrnatment with ID
    
    :param: ID String ("arrow", "circle", "line")
    
    :returns: TBLOrnament?
    */
    func withID(ID: String) -> TBLOrnament? {
		if ID == "arrow" { return TBLOArrow()! }
		if ID == "circle" { return TBLOCircle()! }
		if ID == "line" { return TBLOLine()! }
        return nil
	}
}