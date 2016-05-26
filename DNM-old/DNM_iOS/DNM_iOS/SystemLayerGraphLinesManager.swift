//
//  SystemLayerGraphLinesManager.swift
//  DNM_iOS
//
//  Created by James Bean on 12/23/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation
import DNMModel

public class SystemLayerGraphLinesManager {
    
    private let measureViews: [MeasureView]
    private let leaves: [DurationNode]
    private let performerStratumByPerformerID: [PerformerID: PerformerStratum]
    
    public init(
        leaves: [DurationNode],
        measureViews: [MeasureView],
        performerStratumByPerformerID: [PerformerID: PerformerStratum]
    )
    {
        self.leaves = leaves
        self.measureViews = measureViews
        self.performerStratumByPerformerID = performerStratumByPerformerID
    }
    
    public func manageGraphLines() {
        cutLinesForInstrumentStrataAbsentFromMeasures()
        stopAllLinesAtSystemEnd()
    }
    
    private func stopAllLinesAtSystemEnd() {
        guard let lastMeasureViewRightEdge = measureViews.last?.frame.maxX else { return }
        performerStratumByPerformerID.map { $0.1 }.forEach {
            $0.stopAllLinesAt(lastMeasureViewRightEdge)
        }
    }
    
    private func cutLinesForInstrumentStrataAbsentFromMeasures() {
        measureViews.forEach { cutLinesForInstrumentStrataAbsentFrom($0) }
    }
    
    private func cutLinesForInstrumentStrataAbsentFrom(measureView: MeasureView) {
        let leavesPresent = leavesInMeasure(measureView.measure!)
        cutLinesForLeaves(leavesPresent, presentInMeasureView: measureView)
    }
    
    private func cutLinesForLeaves(leaves: [DurationNode],
        presentInMeasureView measureView: MeasureView
    )
    {
        let idsInMeasure = instrumentIDsByPerformerIDFrom(leaves)
        cutLinesForPerformerIDAndInstrumentIDs(idsInMeasure, inMeasureView: measureView)
    }
    
    private func cutLinesForPerformerIDAndInstrumentIDs(ids: [PerformerID: [InstrumentID]],
        inMeasureView measureView: MeasureView
    )
    {
        for (performerID, instrumentIDs) in ids {
            if let performerStratum = performerStratumByPerformerID[performerID] {
                cutLinesForPerformerStratum(performerStratum,
                    withInstrumentIDs: instrumentIDs,
                    inMeasureView: measureView
                )
            }
        }
    }
    
    private func cutLinesForPerformerStratum(performerStratum: PerformerStratum,
        withInstrumentIDs instrumentIDs: [InstrumentID],
        inMeasureView measureView: MeasureView
    )
    {
        instrumentIDs.forEach {
            if let instrumentStratum = performerStratum.instrumentByID[$0] {
                cutLinesForInstrumentStratum(instrumentStratum, inMeasureView: measureView)
            }
        }
    }
    
    private func cutLinesForInstrumentStratum(instrumentStratum: InstrumentStratum,
        inMeasureView measureView: MeasureView
    )
    {
        instrumentStratum.graphByID.map { $0.1 }.forEach {
            $0.stopLinesAtX(measureView.frame.minX)
        }
    }
    
    private func instrumentIDsByPerformerIDFrom(leaves: [DurationNode])
        -> [PerformerID: [InstrumentID]]
    {
        return leaves.reduce([:]) { $0 + $1.instrumentIDsByPerformerID }
    }
    
    private func leavesInMeasure(measure: MeasureModel) -> [DurationNode] {
        return leaves.filter {
            measure.durationInterval.contains($0.durationInterval.startDuration)
        }
    }
}