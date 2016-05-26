//
//  InstrumentString.swift
//  DNM_iOS
//
//  Created by James Bean on 10/12/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import QuartzCore
import DNMModel

public class InstrumentString: InstrumentStratum {
    
    public var staff_soundingPitch: GraphLayer?
    public var staff_fingeredPitch: GraphLayer?
    
    public override init() { super.init() }
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    public override init(layer: AnyObject) { super.init(layer: layer) }
    
    // TODO: refactor
    /*
    public override func createGraphsWithComponent(component: Component,
        andStaffHeight g: CGFloat
    )
    {
        if component.representationType != .GraphBearing { return }
        //if !component.isGraphBearing { return }
        
        switch component {
        case is ComponentPitch, is ComponentRest:
            if graphByID["soundingPitch"] == nil {
                let soundingPitch = Staff(identifier: "soundingPitch", g: g)
                if let (clefType, transposition, _) = instrumentType?
                    .preferredClefsAndTransposition.first
                {
                    soundingPitch.identifier = "soundingPitch"
                    soundingPitch.pad_bottom = g
                    soundingPitch.pad_top = g
                    soundingPitch.addClefWithType(clefType, withTransposition: transposition, atX: 15)
                    addGraph(soundingPitch, isPrimary: false)
                    staff_soundingPitch = soundingPitch
                }
                else { fatalError("Can't find a proper clef and transposition") }
            }
            
            if graphByID["fingeredPitch"] == nil {
                let fingeredPitch = Staff(identifier: "fingeredPitch", g: g)
                if let (clefType, transposition, _) = instrumentType?
                    .preferredClefsAndTransposition.first
                {
                    fingeredPitch.identifier = "fingeredPitch"
                    fingeredPitch.pad_bottom = g
                    fingeredPitch.pad_top = g
                    fingeredPitch.addClefWithType(clefType,
                        withTransposition: transposition, atX: 15
                    ) // HACK
                    addGraph(fingeredPitch)
                    staff_fingeredPitch = fingeredPitch
                }
                else { fatalError("Can't find a proper clef and transposition") }
            }
        default: break
        }
    }
    
    // TODO: deprecate this in the process of refactoring InstrumentEvent
    public override func createInstrumentEventWithComponent(component: Component,
        atX x: CGFloat, withStemDirection stemDirection: StemDirection
    ) -> InstrumentEvent?
    {
        switch component {
        case is ComponentRest:
            
            let instrumentEvent = InstrumentEvent(
                identifier: "", // tmp
                leaf: DurationNode(), // tmp
                instrumentType: .Violin, // tmp
                stemDirection: stemDirection,
                x: x,
                width: 0 // tmp
            )
            if let fingeredPitch = graphByID["fingeredPitch"] {
                
                // FIXME: Create GraphEventRest, oustide of Graph
                // -- then add to Graph
                /*
                let graphEvent = fingeredPitch.startRestAtX(x, withStemDirection: stemDirection)
                instrumentEvent.addGraphEvent(graphEvent)
                */
            }
            instrumentEvents.append(instrumentEvent)
            return instrumentEvent
        case is ComponentPitch:
            
            let instrumentEvent = InstrumentEvent(
                identifier: "", // tmp
                leaf: DurationNode(), // tmp
                instrumentType: .Viola, // tmp
                stemDirection: stemDirection,
                x: x,
                width: 0 // tmp
            )
            
            
            if let fingeredPitch = graphByID["fingeredPitch"] {
                let graphEvent = fingeredPitch.startEventAtX(x, withStemDirection: stemDirection)
                instrumentEvent.addGraphEvent(graphEvent)
            }
            if let soundingPitch = graphByID["soundingPitch"] {
                let graphEvent = soundingPitch.startEventAtX(x, withStemDirection: stemDirection)
                //graphEvent.isConnectedToStem = false
                //graphEvent.s = 0.75
                instrumentEvent.addGraphEvent(graphEvent)
            }
            instrumentEvents.append(instrumentEvent)
            return instrumentEvent
        default: break
        }
        return nil
    }
    */
}
