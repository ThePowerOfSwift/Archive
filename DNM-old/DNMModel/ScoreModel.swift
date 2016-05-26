//
//  ScoreModel.swift
//  DNMModel
//
//  Created by James Bean on 11/1/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

/**
The model of an entire DNMScore. This will contain:
    * InstrumentTypes organized by InstrumentIDs (ordered), organized by PerformerID (ordered)
    * DurationNodes
    * Measures
    * TempoMarkings
    * RehearsalMarkings

This model will continue expanding as feature set increases
*/
public struct ScoreModel: DurationSpanning, CustomStringConvertible {
    
    /// String representation of ScoreModel
    public var description: String { return getDescription() }
    
    public var metadata: [String: String] = [:]
    
    /// Title of Work
    public var title: String = ""
    
    /// Name of Composer -- make space for multiples, colabs, etc.
    public var composer: String = ""
    
    /// DurationInterval of ScoreModel
    public var durationInterval: DurationInterval { return getDurationInterval() }

    /// All DurationNodes in the piece
    public var durationNodes: [DurationNode] = []
    
    /// All DurationNode Leaves in ScoreModel
    public var leaves: [DurationNode] { return getLeaves() }
    
    /// All Measures in the piece
    public var measures: [MeasureModel] = []
    
    /// All TempoMarkings in the piece
    public var tempoMarkings: [TempoMarking] = []
    
    /// All RehearsalMarkings in the piece
    public var rehearsalMarkings: [RehearsalMarking] = []
    
    public var dynamicMarkingStratumModels: [DynamicMarkingStratumModel] = []
    
    public var labelStratumModels: [LabelStratumModel] = []
    
    /**
    Collection of InstrumentIDsWithInstrumentType, organized by PerformerID.
    These values ensure Performer order and Instrument order,
    while making it still possible to call for this information by key identifiers.
    */
    public var instrumentTypeModel = InstrumentTypeModel()
    
    public var componentTypesByPerformerID: [PerformerID: [ComponentType]] {
        return getComponentTypesByPerformerID()
    }
    
    /**
    Create an empty ScoreModel

    - returns: ScoreModel
    */
    public init() { }
    
    public init(string: String) throws  {
        let tokenContainer = try Tokenizer(string: string).makeToken() as! TokenContainer
        self = try DNMParser().parseRoot(tokenContainer)
    }
    
    public mutating func updateDynamicMarkingStrata() {
        let arranger = DynamicMarkingStratumModelArranger(durationNodes: leaves)
        self.dynamicMarkingStratumModels = arranger.makeDynamicMarkingStratumModels()
    }
    
    public mutating func updateLabelStrata() {
        let arranger = LabelStratumModelArranger(durationNodes: leaves)
        self.labelStratumModels = arranger.makeLabelStratumModels()
    }
    
    // MARK: - Add DurationNode
    public mutating func addDurationNode(durationNode: DurationNode) {
        durationNodes.append(durationNode)
    }
    
    // MARK: - Add Performer
    
    public mutating func addPerformerDeclaration(performerDeclaration: PerformerDeclaration) {
        let pd = performerDeclaration
        instrumentTypeModel[pd.performerID] = pd.instrumentTypeByID
    }
    
    // MARK: - Add Measures
    
    public mutating func setDurationOfLastMeasure(duration duration: Duration) {
        var lastMeasure = measures.removeLast()
        lastMeasure.duration = duration
        measures.append(lastMeasure)
    }
    
    public mutating func addMeasure(var measure: MeasureModel) {
        measure.number = measures.count + 1
        measures.append(measure)
    }
    
    public mutating func addMeasuresWith(subdivisionValue: Int, _ beats: [Int]) {
        beats.forEach { addMeasureWith(($0, subdivisionValue)) }
    }
    
    public mutating func addMeasures(measures: [(Int, Int)]) {
        measures.forEach { addMeasureWith($0) }
    }
    
    public mutating func addMeasureWith(duration: (Int, Int)) {
        addMeasureWith(Duration(duration.0, duration.1))
    }
    
    public mutating func addMeasureWith(duration: Duration) {
        let startDuration = self.measures.last?.durationInterval.stopDuration ?? DurationZero
        self.measures.append(
            MeasureModel(
                durationInterval: DurationInterval(
                    duration: duration,
                    startDuration: startDuration
                )
            )
        )
    }
    
    // MARK: - Add RehearsalMarkings
    
    public mutating func addRehearsalMarkingAt(duration: Duration) {
        let rehearsalMarking = RehearsalMarking(
            index: 0, type: "Alphabetical", offsetDuration: duration
        )
        addRehearsalMarking(rehearsalMarking)
    }
    
    public mutating func addRehearsalMarking(rehearsalMarking: RehearsalMarking) {
        rehearsalMarkings.append(rehearsalMarking)
    }
    
    // MARK: - Add TempoMarkings
    
    public mutating func addTempoMarking(
        tempo: Int, _ subdivisionValue: Int, _ duration: (Int, Int)
        )
    {
        let tempoMarking = TempoMarking(
            value: tempo,
            subdivisionValue: subdivisionValue,
            offsetDuration: Duration(duration.0, duration.1)
        )
        addTempoMarking(tempoMarking)
    }
    
    public mutating func addTempoMarking(tempoMarking: TempoMarking) {
        tempoMarkings.append(tempoMarking)
    }
    
    /**
    Create a subset of this ScoreModel for a given DurationInterval, if possible.
    Will return nil if the DurationInterval does not intersect with the given DurationInterval 
    of this ScoreModel. Slices SpannerNodes and Edges.

    - parameter durationInterval: DurationInterval for which to slice this ScoreModel

    - returns: ScoreModel that is a subset of this ScoreModel, if possible.
    */
    public func scoreModelIn(durationInterval: DurationInterval) -> ScoreModel? {
        return ScoreModelReplicator(scoreModel: self).replicateIn(durationInterval)
    }
    
    /**
    Get the MeasureModel containing a given Duration

    - parameter duration: Duration for which a MeasureModel is desired

    - returns: MeasureModel containing a given Duration, if possible.
    */
    public func measureContaining(duration: Duration) -> MeasureModel? {
        for measure in measures {
            if measure.durationInterval.contains(duration) { return measure }
        }
        return nil
    } 
    
    private func getComponentTypesByPerformerID() -> [PerformerID: [ComponentType]] {
        let componentTypeOrganizer = ScoreModelComponentTypeOrganizer(scoreModel: self)
        return componentTypeOrganizer.componentTypesByPerformerID()
    }
    
    private func getLeaves() -> [DurationNode] {
        return durationNodes.reduce([DurationNode]()) { $0 + ($1.leaves as! [DurationNode]) }
    }
    
    private func getDurationInterval() -> DurationInterval {
        if measures.count == 0 { return DurationIntervalZero }
        return DurationInterval.unionWithDurationIntervals(
            measures.map { $0.durationInterval }
        )
    }
    
    private func getDescription() -> String {
        var description = ""
        description += descriptionForMetadata() + ","
        description += "\n"
        description += "Performers -----------------------------------------------------------"
        description += "\n"
        description += "\(instrumentTypeModel)" + ","
        description += "\n"
        description += descriptionForMeasures() + ","
        description += "\n"
        description += descriptionForDurationNodes() + ","
        description += "\n"
        description += "}"
        return description
    }
    
    private func descriptionForMetadata() -> String {
        var result = ""
        for (key, val) in metadata { result += "\n\(key): \(val)" }
        return result
    }
    
    private func descriptionForMeasures() -> String {
        var result = "Measures ---------------------------------------------------------------"
        measures.forEach { result += "\n\($0.description.indent(amount: 1))" }
        result += "\n"
        return result
    }
    
    private func descriptionForDurationNodes() -> String {
        var result = "DurationNodes ----------------------------------------------------------"
        durationNodes.forEach { result += "\n\n\($0)" }
        result += "\n"
        return result
    }
}

// MARK: - Add Measures

public func += (inout scoreModel: ScoreModel, measureSubdivisionValueAndBeats: (Int, [Int])) {
    scoreModel.addMeasuresWith(
        measureSubdivisionValueAndBeats.0,
        measureSubdivisionValueAndBeats.1
    )
}

// MARK: - Add RehearsalMarkings

public func += (inout scoreModel: ScoreModel, rehearsalMarking: RehearsalMarking) {
    scoreModel.addRehearsalMarking(rehearsalMarking)
}

// MARK: - Add TempoMarkings

public func += (inout scoreModel: ScoreModel, tempoMarking: TempoMarking) {
    scoreModel.addTempoMarking(tempoMarking)
}

public func += (inout scoreModel: ScoreModel, tempoMarking: (Int, Int, (Int, Int))) {
    scoreModel.addTempoMarking(tempoMarking.0, tempoMarking.1, tempoMarking.2)
}

public func += (inout scoreModel: ScoreModel, tempoMarkings: [(Int, Int, (Int, Int))]) {
    tempoMarkings.forEach { scoreModel += $0 }
}