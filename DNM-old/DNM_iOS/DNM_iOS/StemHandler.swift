//
//  StemHandler.swift
//  DNM_iOS
//
//  Created by James Bean on 12/30/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import QuartzCore

public struct StemHandler {
    
    public var instrumentEvent: InstrumentEvent?
    public var beamGroupEvent: BeamGroupEvent
    
    private var stemWidth: CGFloat { return getStemWidth() }
    private var stemColor: CGColorRef { return getStemColor() }
    
    public init(beamGroupEvent: BeamGroupEvent, instrumentEvent: InstrumentEvent? = nil) {
        self.instrumentEvent = instrumentEvent
        self.beamGroupEvent = beamGroupEvent
    }
    
    public func makeStemIn(context: CALayer) -> Stem {
        let infoEndY = getInfoEndYInContext(context)
        let beamEndY = getBeamEndYInContext(context)
        if let stem_x = beamGroupEvent.x_objective {
            let stem = Stem(x: stem_x, beamEndY: beamEndY, infoEndY: infoEndY)
            configureStem(stem)
            return stem
        } else {
            fatalError("could not create stem")
        }
    }
    
    private func configureStem(stem: Stem) {
        setVisualAttributesFor(stem)
        setStemForBeamGroupEventAndInstrumentEvent(stem)
        setBeamGroupEventAndInstrumentEventFor(stem)
    }
    
    private func setStemForBeamGroupEventAndInstrumentEvent(stem: Stem) {
        beamGroupEvent.stem = stem
    }
    
    private func setBeamGroupEventAndInstrumentEventFor(stem: Stem) {
        stem.bgEvent = beamGroupEvent
        stem.instrumentEvent = instrumentEvent
    }
    
    private func setVisualAttributesFor(stem: Stem) {
        stem.lineWidth = stemWidth
        stem.color = stemColor
    }
    
    private func getInfoEndYInContext(context: CALayer) -> CGFloat {
        if let instrumentEvent = instrumentEvent
            where instrumentEvent.hasGraphBearingComponents
        {
            return infoEndYForGraphEventPresentIn(context)
        } else {
            return infoEndYForRestOrExtensionIn(context)
        }
    }
    
    private func infoEndYForGraphEventPresentIn(context: CALayer) -> CGFloat {
        guard let instrumentEvent = instrumentEvent else { return 0 }
        return instrumentEvent.stemEndYIn(context)
    }
    
    private func infoEndYForRestOrExtensionIn(context: CALayer) -> CGFloat {
        guard let bgStratum = beamGroupEvent.bgStratum else { return 0 }
        
        // TODO: find cleaner way
        switch bgStratum.viewModel.stemDirection {
        case .Down:
            if let durationalExtensionNode = bgStratum.durationalExtensionNode {
                return context.convertY(durationalExtensionNode.frame.maxY, fromLayer: bgStratum)
            }
            return context.convertY(bgStratum.frame.height, fromLayer: bgStratum)
        case .Up:
            if let durationalExtensionNode = bgStratum.durationalExtensionNode {
                return context.convertY(durationalExtensionNode.frame.minY, fromLayer: bgStratum)
            } else {
                return context.convertY(0, fromLayer: bgStratum)
            }
        }
    }
    
    private func getBeamEndYInContext(context: CALayer) -> CGFloat {
        if let bgStratum = beamGroupEvent.bgStratum {
            return context.convertY(bgStratum.beamEndY, fromLayer: bgStratum.beamsLayerGroup!)
        }
        else { return 0 }
    }
    
    private func getStemWidth() -> CGFloat {
        if let staffSpaceHeight = beamGroupEvent.bgStratum?.viewModel.staffSpaceHeight {
            return 0.1 * staffSpaceHeight
        } else {
            return 1
        }
    }
    
    private func getStemColor() -> CGColorRef {
        if let depth = beamGroupEvent.depth {
            let hue = HueByTupletDepth[depth - 1]
            return DNMColor.colorWithHue(hue, andDepthOfField: .MostForeground).CGColor
        } else {
            return DNMColor.grayscaleColorWithDepthOfField(.Middleground).CGColor
        }
    }
}