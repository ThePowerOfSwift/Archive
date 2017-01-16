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
    
    let pitchSet: Set<StaffRepresentablePitch>

    public init <S: Sequence> (_ sequence: S)
         where S.Iterator.Element == StaffRepresentablePitch
    {
        self.pitchSet = Set(sequence)
    }
    
    public func ledgerLinesAbove(_ clef: StaffClef) -> Int {
        
        guard let highest = pitchSet.max()?.spelledPitch else {
            return 0
        }

        let distance = clef.coordinate(highest) - 6
        return ledgerLinesAmount(distance: distance)
    }
    
    public func ledgerLinesBelow(_ clef: StaffClef) -> Int {
        
        guard let lowest = pitchSet.min()?.spelledPitch else {
            return 0
        }
        
        let distance = abs(clef.coordinate(lowest)) - 6
        return ledgerLinesAmount(distance: distance)

    }
    
    private func ledgerLinesAmount(distance: Int) -> Int {
        return distance >= 0 ? distance / 2 + 1 : 0
    }
}
