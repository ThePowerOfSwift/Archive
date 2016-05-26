//
//  DNMParser.swift
//  DNMModel
//
//  Created by James Bean on 1/24/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public class DNMParser {
    
    internal enum Error: ErrorType {
        case InvalidRootTokenContainer
        case InvalidLineTokenContainer
        case InvalidMeasureTokenContainer
        case InvalidDurationTokenContainer
    }
    
    private enum DurationNodeStackMode {
        case Measure, Increment
    }
    
    private var durationNodeStackMode: DurationNodeStackMode = .Measure
    
    private var durationNodeContainerStack = Stack<DurationNode>()
    private var durationNodeDepth: Int = 0
    
    private var offsetDurationOfCurrentMeasure: Duration = DurationZero
    private var offsetDurationFromBeginningOfCurrentMeasure: Duration = DurationZero
    private var offsetDurationOfCurrentDurationNodeRoot: Duration = DurationZero
    private var offsetDurationFromBeginningOfPiece: Duration = DurationZero
    
    private var performerID: PerformerID?
    private var instrumentID: InstrumentID?
    
    // The ScoreModel that is modified and returned by parseRoot(tokenContainer:)
    private var scoreModel: ScoreModel = ScoreModel()
    
    public func parseRoot(tokenContainer: TokenContainer) throws -> ScoreModel {
        guard tokenContainer.identifier == "Root" else { throw Error.InvalidRootTokenContainer }
        for token in tokenContainer.tokens {
            if let lineTokenContainer = token as? TokenContainer {
                try parseLine(lineTokenContainer)
            }
        }
        setDurationOfPreviousMeasureInContext()
        updateStrata()
        return scoreModel
    }
    
    private func updateStrata() {
        scoreModel.updateDynamicMarkingStrata()
        scoreModel.updateLabelStrata()
    }
    
    private func parseLine(tokenContainer: TokenContainer) throws {
        guard tokenContainer.identifier == "Line" else { throw Error.InvalidLineTokenContainer }
        for token in tokenContainer.tokens { try parse(token) }
    }
    
    private func parse(token: Token) throws {
        guard let tokenContainer = token as? TokenContainer else { return }
        switch token.identifier {
        case "PerformerDeclaration":
            try performerDeclaration(tokenContainer)
        case "Measure":
            try measure(tokenContainer)
        case "DurationNodeStackModeMeasure":
            try durationNodeStackModeMeasure(tokenContainer)
        case "DurationNodeStackModeIncrement":
            try durationNodeStackModeIncrement(tokenContainer)
        case "Label":
            break
        case "RehearsalMarking":
            break
        case "TempoMarking":
            break
        case "Leaf":
            try leaf(tokenContainer)
        default:
            break
        }
    }
    
    private func performerDeclaration(tokenContainer: TokenContainer) throws {
        let declaration = try PerformerDeclarationParser().parse(tokenContainer)
        scoreModel.addPerformerDeclaration(declaration)
    }
    
    private func measure(tokenContainer: TokenContainer) throws {
        guard tokenContainer.identifier == "Measure" else {
            throw Error.InvalidMeasureTokenContainer
        }
        setDurationOfPreviousMeasureInContext()
        addMeasureWithOffsetDurationFromContext()
        
        // manage explicit duration:
        
        // wrap
        guard tokenContainer.tokens.count > 0 else { return }
        
        // wrap
        guard let durationContainer = tokenContainer.tokens.first as? TokenContainer else {
            throw Error.InvalidDurationTokenContainer
        }
        
        // wrap
        guard let beatsToken = durationContainer.tokens.first as? TokenInt,
            let subdivisionValueToken = durationContainer.tokens.second as? TokenInt else  {
            throw Error.InvalidDurationTokenContainer
        }
        
        let beats = beatsToken.value
        let subdivisionValue = subdivisionValueToken.value
        scoreModel.setDurationOfLastMeasure(duration: Duration(beats, subdivisionValue))
    }
    
    private func setDurationOfPreviousMeasureInContext() {
        guard scoreModel.measures.count > 0 else { return }
        let duration = offsetDurationFromBeginningOfCurrentMeasure
        if scoreModel.measures.last?.duration == DurationZero {
            scoreModel.setDurationOfLastMeasure(duration: duration)
        }
        updateOffsetDurationOfCurrentMeasure()
    }
    
    private func updateOffsetDurationOfCurrentMeasure() {
        guard let lastMeasure = scoreModel.measures.last else { return }
        offsetDurationOfCurrentMeasure = lastMeasure.durationInterval.stopDuration
    }
    
    private func addMeasureWithOffsetDurationFromContext() {
        let measure = MeasureModel(offsetDuration: offsetDurationOfCurrentMeasure)
        scoreModel.addMeasure(measure)
    }
    
    private func durationNodeStackModeMeasure(tokenContainer: TokenContainer) throws {
        durationNodeStackMode = .Measure
        guard let root = tokenContainer.tokens.first as? TokenContainer else {
            throw Error.InvalidDurationTokenContainer
        }
        offsetDurationFromBeginningOfCurrentMeasure = DurationZero
        offsetDurationFromBeginningOfPiece = offsetDurationOfCurrentMeasure
        try durationNodeRoot(root)
    }
    
    private func durationNodeStackModeIncrement(tokenContainer: TokenContainer) throws {
        durationNodeStackMode = .Increment
        guard let root = tokenContainer.tokens.first as? TokenContainer else {
            throw Error.InvalidDurationTokenContainer
        }
        try durationNodeRoot(root)
    }
    
    private func durationNodeRoot(tokenContainer: TokenContainer) throws {
        if let performerID = (tokenContainer.tokens[safe: 1] as? TokenString)?.value,
            let instrumentID = (tokenContainer.tokens[safe: 2] as? TokenString)?.value
        {
            setPerformerID(performerID, andInstrumentID: instrumentID)
            if let durationTokenContainer = tokenContainer.tokens[safe: 0] as? TokenContainer {
                let duration = try durationFrom(durationTokenContainer)
                addDurationNodeWith(duration)
            } else {
                addDurationNodeIntervalInferring()
            }
        } else {
            throw Error.InvalidDurationTokenContainer
        }
    }
    
    private func setPerformerID(performerID: PerformerID,
        andInstrumentID instrumentID: InstrumentID
    )
    {
        self.performerID = performerID
        self.instrumentID = instrumentID
    }
    
    private func durationFrom(tokenContainer: TokenContainer) throws -> Duration {
        guard tokenContainer.identifier == "MetricalDuration" else {
            throw Error.InvalidDurationTokenContainer
        }
        guard let beatsToken = tokenContainer.tokens[safe: 0] as? TokenInt else {
            throw Error.InvalidDurationTokenContainer
        }
        guard let subdivisionValueToken = tokenContainer.tokens[safe: 1] as? TokenInt else {
            throw Error.InvalidDurationTokenContainer
        }
        return Duration(beatsToken.value, subdivisionValueToken.value)
    }
    
    private func addDurationNodeWith(duration: Duration) {
        let durationNode = DurationNode.with(duration)
        setOffsetDurationFor(durationNode)
        addDurationNode(durationNode)
        incrementDurationCountersBy(duration)
    }
    
    private func setOffsetDurationFor(durationNode: DurationNodeIntervalEnforcing) {
        durationNode.offsetDuration = offsetDurationFromBeginningOfPiece
    }
    
    private func addDurationNode(durationNode: DurationNode) {
        scoreModel.addDurationNode(durationNode)
        durationNodeContainerStack.push(durationNode)
    }
    
    private func incrementDurationCountersBy(duration: Duration) {
        offsetDurationFromBeginningOfCurrentMeasure += duration
        offsetDurationFromBeginningOfPiece += duration
    }
    
    private func addDurationNodeIntervalInferring() {
        let durationNode = DurationNodeIntervalInferring()
        addDurationNode(durationNode)
    }
    
    // TODO: refactor
    private func leaf(tokenContainer: TokenContainer) throws {
        if let relativeDurationToken = tokenContainer.tokens[safe: 0] as? TokenFloat {
            var leaf: DurationNode?
            if let currentDurationNodeRoot = durationNodeContainerStack.top
                as? DurationNodeIntervalEnforcing
            {
                let beats = Int(relativeDurationToken.value)
                
                // TODO: refactor to private method
                if tokenContainer.hasTokenWith("EdgeStop") {
                    if let lastLeaf = currentDurationNodeRoot.leaves.last
                        as? DurationNodeIntervalEnforcing
                    {
                        let newDuration = Duration(beats: beats) - lastLeaf.durationInterval.startDuration
                        lastLeaf.duration = newDuration
                    }
                } else {
                    leaf = currentDurationNodeRoot.addChildWith(beats)
                }
            } else if let currentDurationNodeRoot = durationNodeContainerStack.top
                as? DurationNodeIntervalInferring
            {
                let offsetDuration = Duration(floatValue: relativeDurationToken.value)
                if tokenContainer.hasTokenWith("EdgeStop") {
                    
                    // TODO: refactor to private method
                    if let lastLeaf = currentDurationNodeRoot.leaves.last
                        as? DurationNodeIntervalEnforcing
                    {
                        let newDuration = offsetDuration - lastLeaf.durationInterval.startDuration
                        lastLeaf.duration = newDuration
                    }
                } else {
                    leaf = currentDurationNodeRoot.addChildAt(offsetDuration)
                }
            } else {
                throw Error.InvalidDurationTokenContainer
            }
            
            guard let performerID = performerID, instrumentID = instrumentID else {
                throw Error.InvalidDurationTokenContainer
            }
            
            let componentParser = ComponentParser(
                performerID: performerID, instrumentID: instrumentID
            )
            
            if let leaf = leaf {
                let components = try componentParser.parse(tokenContainer)
                leaf.components = components
            }
        } else {
            throw Error.InvalidDurationTokenContainer
        }
    }
}