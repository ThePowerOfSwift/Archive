//
//  InstrumentEventRenderer.swift
//  DNM
//
//  Created by James Bean on 1/13/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import QuartzCore
import DNMModel

public class InstrumentEventRenderer: SystemContextualized {
    
    public let instrumentEvents: [InstrumentEvent]
    public let viewerProfile: ViewerProfile
    public let systemOffsetDuration: Duration
    public let infoStartX: CGFloat
    public let beatWidth: BeatWidth
    public let defaultStaffHeight: StaffSpaceHeight
    public let scale: Scale
    
    public init(
        instrumentEvents: [InstrumentEvent],
        systemContextSpecifier: SystemContextSpecifier = SystemContextSpecifier(),
        sizeSpecifier: StaffTypeSizeSpecifier = StaffTypeSizeSpecifier(),
        beatWidth: BeatWidth = 110
    )
    {
        self.instrumentEvents = instrumentEvents
        self.viewerProfile = systemContextSpecifier.viewerProfile
        self.systemOffsetDuration = systemContextSpecifier.offsetDuration
        self.infoStartX = systemContextSpecifier.infoStartX
        self.defaultStaffHeight = sizeSpecifier.staffSpaceHeight
        self.scale = sizeSpecifier.scale
        self.beatWidth = beatWidth
    }
    
    public func renderInstrumentEventsTo(performerStrata: [PerformerStratum]) {
        instrumentEvents.forEach { render($0, toPerformerStrata: performerStrata) }
    }
    
    private func render(instrumentEvent: InstrumentEvent,
        toPerformerStrata performerStrata: [PerformerStratum]
    )
    {
        for graphEvent in instrumentEvent.graphEvents {
            print("graphEvent: \(graphEvent)")
        }
    }
    
    
}