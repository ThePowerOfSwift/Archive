//
//  StaffInformationRenderer.swift
//  Staff
//
//  Created by James Bean on 1/11/17.
//
//

import QuartzCore
import Color
import Pitch
import PitchSpellingTools
import GraphicsTools

public struct StaffInformationRenderer: Renderer {
    
    let clef: StaffClef
    let pitch: SpelledPitch
    
    public func render(
        in context: CALayer,
        with configuration: StaffInformationConfiguration
    )
    {
        
        let representable = StaffRepresentablePitch(pitch)
        let represented = StaffRepresentedPitch(
            representableContext: representable,
            altitude: 0,
            staffSlotHeight: 20
        )
        
        let staffSlot = clef.coordinate(pitch)
        
        represented.accidental.color = Color.red
        represented.accidental.position.x += 200
        represented.notehead.position.x += 170
        represented.accidental.position.y += 200
        represented.notehead.position.y += 200
        represented.notehead.color = configuration.noteheadColor
        context.addSublayer(represented.accidental)
        context.addSublayer(represented.notehead)
    }
    
    // take in clef
    public init(clef: StaffClef = StaffClef(.treble), pitch: SpelledPitch) {
        self.clef = clef
        self.pitch = pitch
    }
}
