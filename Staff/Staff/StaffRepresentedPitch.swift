//
//  StaffRepresentedPitch.swift
//  Staff
//
//  Created by James Bean on 6/15/16.
//
//

import QuartzCore

public struct StaffRepresentedPitch {
    
    private let representableContext: StaffRepresentablePitch
    private let altitude: CGFloat
    private let staffSlotHeight: StaffSlot

    // make these weak vars?
    public let notehead: Notehead
    public let accidental: Accidental
    
    public init(
        representableContext: StaffRepresentablePitch,
        altitude: CGFloat, // calculate altitude within staffEvent?
        staffSlotHeight: StaffSlot
    )
    {
        self.representableContext = representableContext
        self.altitude = altitude
        self.staffSlotHeight = staffSlotHeight
        
        self.notehead = Notehead(
            point: CGPoint(x: 0, y: self.altitude),
            staffSlotHeight: self.staffSlotHeight
        )
        
        self.accidental = Accidental.makeAccidental(
            withKind: self.representableContext.accidentalKind,
            point: CGPoint(x: 0, y: self.altitude),
            staffSlotHeight: self.staffSlotHeight
        )
    }
}
