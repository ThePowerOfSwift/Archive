//
//  BeamGroupStratumFactory.swift
//  DNM_iOS
//
//  Created by James Bean on 11/27/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import QuartzCore
import DNMModel

// TODO: subclass of ComponentNodeRender

/// Creates BeamGroupStrata from unorganized DurationNodes for a single System's worth of music
public class BeamGroupStratumFactory: ComponentNodeRenderer {
    
    public func makeBeamGroupStrataWith(componentFilters: ComponentFilters) -> [BeamGroupStratum] {
        let durationNodeStrata = makeDurationNodeStrataWith(componentFilters)
        return makeBeamGroupStrataWith(durationNodeStrata)
    }
    
    private func makeBeamGroupStrataWith(durationNodeStrata: [DurationNodeStratum])
        -> [BeamGroupStratum]
    {
        // for each DurationNodeStratum, create a BeamGroupStratum
        return durationNodeStrata.map {
            
            // makes the assumption that there is only a single performerID per rhythm
            let performerID = performerIDsInStratum($0).first!
            let stemDirection = stemDirectionFor(performerID)
            let staffSpaceHeight = staffSpaceHeightFor(performerID)
            
            // create ViewModel for BeamGroupStratum
            let beamGroupStratumViewModel = BeamGroupStratumViewModel(
                model: $0,
                graphicalAttributeSpecifier: BeamGroupGraphicalAttributeSpecifier(
                    origin: CGPoint(x: infoStartX, y: 0),
                    stemDirection: stemDirection,
                    beatWidth: beatWidth,
                    sizeSpecifier: StaffTypeSizeSpecifier(
                        staffSpaceHeight: staffSpaceHeight,
                        scale: 1.0
                    ),
                    temporalRenderAttributeSpecifier: BeamGroupTemporalRenderAttributeSpecifier(
                        showMetrics: true, // needs to be specified by DurationNode
                        showNumerics: true // needs to be specified by DurationNode
                    )
                )
            )
            // create BeamGroupStratum with BeamGroupStratumViewModel
            return BeamGroupStratum(viewModel: beamGroupStratumViewModel)
        }
    }
    
    private func makeDurationNodeStrataWith(componentFilters: ComponentFilters)
        -> [DurationNodeStratum]
    {
        var durationNodeStratumArranger = DurationNodeStratumArranger(
            durationNodes: durationNodes,
            durationOffset: systemOffsetDuration
        )
        durationNodeStratumArranger.makeDurationNodeStrataWith(componentFilters)
        return durationNodeStratumArranger.makeDurationNodeStrata()
    }
    
    private func performerIDsInStratum(stratum: DurationNodeStratum) -> [PerformerID] {
        return stratum.reduce([]) { $0 + performerIDsInDurationNode($1) }
    }
    
    private func performerIDsInDurationNode(durationNode: DurationNode) -> [PerformerID] {
        return Array<String>(durationNode.instrumentIDsByPerformerID.keys)
    }
}

