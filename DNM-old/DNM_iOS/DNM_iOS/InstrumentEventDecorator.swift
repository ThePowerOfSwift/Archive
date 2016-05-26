//
//  InstrumentEventDecorator.swift
//  DNM_iOS
//
//  Created by James Bean on 12/22/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit
import DNMModel

/// Decorates an InstrumentEvent with a Component
public class InstrumentEventDecorator {
    
    private let instrumentEvent: InstrumentEvent
    private let component: Component
    
    // temp?
    private let beatWidth: BeatWidth
    
    
    /**
    Create an InstrumentEventDecorator

    - parameter instrumentEvent: InstrumentEvent to decorate
    - parameter component:       Component with which to decorate the InstrumentEvent

    - returns: InstrumentEventDecorator
    */
    public init(instrumentEvent: InstrumentEvent, component: Component, beatWidth: BeatWidth) {
        self.instrumentEvent = instrumentEvent
        self.component = component
        self.beatWidth = beatWidth
    }
    
    /**
    Adds necessary musical information to an Instrument's Graphs
    */
    public func decorate() {
        switch component {
        case is ComponentRest: decorateRest()
        case let componentPitch as ComponentPitch: decorate(componentPitch)
        case is ComponentNode: decorateNode()
        case is ComponentEdge: decorateEdge()
        case let componentArticulation as ComponentArticulation: decorate(componentArticulation)
        default: break
        }
    }
    
    private func decorateRest() {
        // TODO
    }
    
    private func decorateNode() {

    }
    
    private func decorateEdge() {
        for graphEvent in instrumentEvent.graphEvents {

            // TODO: manage this properly
            graphEvent.leaf = instrumentEvent.leaf
            
            // TODO: manage this internally
            if let leaf = graphEvent.leaf {
                let w = leaf.width(beatWidth: beatWidth)
                
                // TODO: manage this internally within GraphEvent
                let edge = CAShapeLayer()
                let edgePath = UIBezierPath()
                
                // FIXME: this should just be 0 -> w, not x -> x + w; check graphEvent.setFrame()
                edgePath.moveToPoint(CGPoint(x: graphEvent.x, y: 0))
                edgePath.addLineToPoint(CGPoint(x: graphEvent.x + w, y: 0))
                edge.path = edgePath.CGPath
                edge.lineWidth = 4
                edge.strokeColor = UIColor.grayColor().CGColor
                graphEvent.addSublayer(edge)
            }
        }
    }
    
    // Refactor into own class: InstrumentEventPitchDecorator
    private func decorate(componentPitch: ComponentPitch) {
        for graphEvent in instrumentEvent.graphEvents {
            
            if let staffEvent = graphEvent as? StaffEvent {
                componentPitch.values.forEach { staffEvent.addPitch(Pitch(midi: MIDI($0))) }
            }
        }
    }
    
    // Refactor into own class: InstrumentEventArticulationDecorator
    private func decorate(componentArticulation: ComponentArticulation) {
        for graphEvent in instrumentEvent.graphEvents {
            componentArticulation.values.forEach {
                if let type = ArticulationTypeWithMarking($0) {
                    switch type {
                    case .Tremolo: break // manage stemArticulations
                    default: graphEvent.addArticulationWithType(type)
                    }
                }
            }
        }
    }
}