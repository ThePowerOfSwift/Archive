import QuartzCore
import UIKit

/**
TBLigature (Tuplet Bracket Ligature) Factory
*/
class CreateTBLigature {
    
    /**
    Create TBLigature with ID
    
    :param: ID String ("start", "end", "reintroduce")
    
    :returns: TBLigature?
    */
    func withID(ID: String) -> TBLigature? {
        if ID == "start" { return TBLStart()! }
        if ID == "end" { return TBLEnd()! }
        if ID == "reintroduce" { return TBLReintroduce()! }
        if ID == "reintroduceTruncated" { return TBLReintroduceTruncated()! }
        return nil
    }
}