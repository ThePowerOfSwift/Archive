//
//  StaffPointModel.swift
//  Staff
//
//  Created by James Bean on 1/14/17.
//
//

import Plot

// TODO:
//import Articulations

public struct StaffPointModel {
    
    let elements: Set<StaffRepresentablePitch>

    public init <S: Sequence> (_ sequence: S)
         where S.Iterator.Element == StaffRepresentablePitch
    {
        self.elements = Set(sequence)
    }
    
    /// - returns: Ledger lines above and below
    public func ledgerLines(_ clef: StaffClef) -> (Int, Int) {
        return (ledgerLinesAbove(clef), ledgerLinesBelow(clef))
    }
    
    private func ledgerLinesAbove(_ clef: StaffClef) -> Int {
        
        guard let highest = elements.max()?.spelledPitch else {
            return 0
        }

        return ledgerLinesAmount(distance: clef.coordinate(highest) - 6)
    }
    
    private func ledgerLinesBelow(_ clef: StaffClef) -> Int {
        
        guard let lowest = elements.min()?.spelledPitch else {
            return 0
        }

        return ledgerLinesAmount(distance: abs(clef.coordinate(lowest)) - 6)
    }
    
    private func ledgerLinesAmount(distance: Int) -> Int {
        return distance >= 0 ? distance / 2 + 1 : 0
    }
}
