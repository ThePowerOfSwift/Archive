//
//  StaffPitchSetRenderer.swift
//  Staff
//
//  Created by James Bean on 1/13/17.
//
//

import Pitch
import PitchSpellingTools
import GraphicsTools
import QuartzCore

public struct StaffPitchSetRenderer: Renderer {

    let clef: StaffClef
    let pitchSet: SpelledPitchSet
    let ledgerLineRenderDelegate: LedgerLineRenderDelegate
    
    var ledgerLinesAboveCount: Int {
        
        guard let highest = pitchSet.max() else {
            return 0
        }
        
        let diff = clef.coordinate(highest) - 4
        return diff > 0 ? diff : 0
        
    }
    
    var ledgerLinesBelowCount: Int {
        
        guard let lowest = pitchSet.min() else {
            return 0
        }
        
        let diff = abs(clef.coordinate(lowest)) - 4
        return diff > 0 ? diff : 0
    }
    
    init(
        _ pitchSet: SpelledPitchSet,
        clef: StaffClef, 
        ledgerLineRenderDelegate: LedgerLineRenderDelegate
    )
    {
        self.pitchSet = pitchSet
        self.clef = clef
        self.ledgerLineRenderDelegate = ledgerLineRenderDelegate
    }
    
    public func render(
        in context: CALayer,
        with configuration: StaffInformationConfiguration
    )
    {
        fatalError()
    }
}

// calculate ledger lines above
// calculate ledger lines below
