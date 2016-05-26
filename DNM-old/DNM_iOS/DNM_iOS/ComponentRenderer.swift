//
//  ComponentRenderer.swift
//  DNM_iOS
//
//  Created by James Bean on 12/23/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import QuartzCore
import DNMModel

public class ComponentRenderer: SystemContextualized {
    
    private let instrumentEvents: [InstrumentEvent]
    private let performerStratumByID: [PerformerID: PerformerStratum]
    internal let viewerProfile: ViewerProfile
    internal let systemOffsetDuration: Duration
    internal let infoStartX: CGFloat
    internal let beatWidth: BeatWidth
    internal let defaultStaffHeight: StaffSpaceHeight
    internal let scale: Scale
    
    public init(
        instrumentEvents: [InstrumentEvent],
        performerStratumByID: [PerformerID: PerformerStratum],
        systemContextSpecifier: SystemContextSpecifier = SystemContextSpecifier(),
        sizeSpecifier: StaffTypeSizeSpecifier = StaffTypeSizeSpecifier(),
        beatWidth: BeatWidth = 110
    )
    {
        self.instrumentEvents = instrumentEvents
        self.performerStratumByID = performerStratumByID
        self.viewerProfile = systemContextSpecifier.viewerProfile
        self.systemOffsetDuration = systemContextSpecifier.offsetDuration
        self.infoStartX = systemContextSpecifier.infoStartX
        self.beatWidth = beatWidth
        self.defaultStaffHeight = sizeSpecifier.staffSpaceHeight
        self.scale = sizeSpecifier.scale
    }
    
    public func renderComponentsWith(componentFilters: ComponentFilters) {
        
        let instrumentEvents = instrumentEventsFilteredBy(componentFilters)
        
        instrumentEvents.forEach {
            
            let instrumentID = $0.instrument.identifierPath.instrumentID
            let performerID = $0.instrument.identifierPath.performerID
            
            // validate performerStratum for PerformerID
            guard let performerStratum = performerStratumByID[performerID] else {
                fatalError("PerformerStratum does not exist for: \(performerID)")
            }
            
            // validate instrumentStratum for InstrumentID
            guard let instrumentStratum = performerStratum.instrumentByID[instrumentID] else {
                fatalError("InstrumentStratum does not exist for: \(instrumentID)")
            }
            
            instrumentStratum.addInstrumentEvent($0)
        }
        
    }
    
    private func instrumentEventsFilteredBy(componentFilters: ComponentFilters)
        -> [InstrumentEvent]
    {
        var result: [InstrumentEvent] = []
        for componentFilter in componentFilters {
            for (performerID, componentTypes) in componentFilter.componentTypesShownByPerformerID {
                var events = instrumentEvents
                events = instrumentEventsFrom(events, inComponentFilter: componentFilter)
                events = instrumentEventsFrom(events, withPerformerID: performerID)
                events = filterOutAllComponentTypesBut(componentTypes, fromInstrumentEvents: events)
                prepareGraphEventsFor(events)
                result.appendContentsOf(events)
            }
        }
        return result
    }
    
    
    private func prepareGraphEventsFor(instrumentEvents: [InstrumentEvent]) {
        instrumentEvents.forEach { $0.prepareGraphEvents() }
    }
    
    private func filterOutAllComponentTypesBut(componentTypes: [ComponentType],
        fromInstrumentEvents instrumentEvents: [InstrumentEvent]
    ) -> [InstrumentEvent]
    {
        instrumentEvents.forEach { $0.filterOutAllComponentTypesBut(componentTypes) }
        return instrumentEvents
    }
    
    private func instrumentEventsFrom(instrumentEvents: [InstrumentEvent],
        withPerformerID performerID: PerformerID
    ) -> [InstrumentEvent]
    {
        return instrumentEvents.filter { $0.leaf.hasComponentWithPerformerID(performerID) }
    }
    
    private func instrumentEventsFrom(instrumentEvents: [InstrumentEvent],
        withComponentType componentType: ComponentType
    ) -> [InstrumentEvent]
    {
        return instrumentEvents.filter { $0.leaf.hasComponentWithType(componentType) }
    }
    
    private func instrumentEventsFrom(instrumentEvents: [InstrumentEvent],
        inComponentFilter componentFilter: ComponentFilter
    ) -> [InstrumentEvent]
    {
        return instrumentEvents.filter {
            componentFilter.durationInterval.contains($0.leaf.durationInterval.startDuration)
        }
    }
}