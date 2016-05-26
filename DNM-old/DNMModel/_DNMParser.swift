//
//  DNMParser.swift
//  DNMConverter
//
//  Created by James Bean on 11/9/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

// IN-PROCESS: Refactor (2016-01-26)
/*
import Foundation

/// Create ScoreModel from a TokenContainer (produced by DNMTokenizer, tokenizing a DNM file)
public class DNMParser {
    
    /**
    Manner in which the `Duration` of the current `MeasureModel` is defined

    - Implicit: Calculated based on `DurationNodes` declared within bounds of `Measure`
    - Explicit: Set by user by immediately preceeding `Measure` command with `Duration` command
    */
    private enum MeasureStackMode {
        case Implicit
        case Explicit
    }
    
    /**
    Manner in which the current `DurationNode` is placed in time

    - Measure:   Place `DurationNode` at beginning of current `Measure`
    - Increment: Place `DurationNode` immediately after last `DurationNode`
    - Decrement: Place `DurationNode` at beginning of last `DurationNode`
    */
    private enum DurationNodeStackMode: String {
        case Measure = "|"
        case Increment = "+"
        case Decrement = "-"
    }
    
    private enum NextDurationReceivingType {
        case Measure
        case DurationNode
    }
    
    private enum DurationNodeIntervalType {
        case Enforcing
        case Inferring
    }
    
    private var durationNodeIntervalType: DurationNodeIntervalType = .Enforcing
    private var currentMeasureStackMode: MeasureStackMode = .Implicit
    private var currentDurationNodeStackMode: DurationNodeStackMode = .Measure
    private var nextDurationReceivingType: NextDurationReceivingType = .Measure
    
    /// Stack of DurationNodes, used to embed DurationNodes into other ones
    private var durationNodeContainerStack = Stack<DurationNode>()
    
    /// Current DurationNodeLeaf which shall be decorated with Components
    private var currentDurationNodeLeaf: DurationNode?
    
    /// Offset of start of current measure from the beginning of the piece
    private var currentMeasureDurationOffset: Duration = DurationZero
    
    /// Offset of current location from beginning of current measure
    private var accumDurationInMeasure: Duration = DurationZero
    
    /// Offset of current DurationNode from beginning of the piece
    private var currentDurationNodeOffset: Duration = DurationZero
    
    /// Depth of current DurationNode (in the case of embedded tuplets)
    private var currentDurationNodeDepth: Int = 0
    
    private var currentPerformerID: String?
    private var currentInstrumentID: String?
    private var currentMetadataKey: String?
    
    /**
    Collection of InstrumentIDsWithInstrumentType, organized by PerformerID.
    These values ensure Performer order and Instrument order, 
    while making it still possible to call for this information by key identifiers.
    */
    private var instrumentTypeModel = InstrumentTypeModel()
    
    // MARK: - ScoreModel values
    
    private var metadata: [String: String] = [:]
    private var title: String = ""
    private var durationNodes: [DurationNode] = []
    private var measures: [MeasureModel] = []
    private var tempoMarkings: [TempoMarking] = []
    private var rehearsalMarkings: [RehearsalMarking] = []
    
    /**
    Create a DNMParser

    - returns: DNMParser
    */
    public init() { }
    
    /**
    Parse a TokenContainer (produced by DNMTokenizer)

    - parameter tokenContainer: TokenContainer containing all Tokens of a musical work

    - returns: ScoreModel (musical model to be represented by DNMRenderer)
    */
    public func parseTokenContainer(tokenContainer: TokenContainer) -> ScoreModel {
        tokenContainer.tokens.forEach { parse($0) }
        setDurationOfLastMeasureFromContext()
        finalizeDurationNodes()
        let scoreModel = makeScoreModel()
        return scoreModel
    }
    
    private func parse(token: Token) {
        if let container = token as? TokenContainer {
            switch container.identifier {
            case "PerformerDeclaration":
                managePerformerDeclarationTokenContainer(container)
            case "Rest": manageRestToken()
            case "Node": manageNodeToken()
            case "Edge": manageEdgeToken()
            case "Pitch": managePitchTokenContainer(container)
            case "DynamicMarking": manageDynamicMarkingTokenContainer(container)
            case "Articulation": manageArticulationTokenContainer(container)
            case "SlurStart": manageSlurStartToken()
            case "SlurStop": manageSlurStopToken()
            case "Measure": manageMeasureToken()
            case "ExtensionStart": manageExtensionStartToken()
            case "ExtensionStop": manageExtensionStopToken()
            case "DurationNodeStackModeMeasure": manageDurationNodeStackModeMeasure()
            case "DurationNodeStackModeIncrement": manageDurationNodeStackModeIncrement()
            case "DurationNodeStackModeDecrement": manageDurationNodeStackModeDecrement()
            case "NonNumericalDurationNodeMode": manageNonNumericalDurationNodeModeToken()
            case "NonMetricalDurationNodeMode": manageNonMetricalDurationNodeModeToken()
            case "DurationNodeIntervalType": manageDurationNodeIntervalInferringType()
            default: break
            }
        }
        else {
            switch token.identifier {
            case "Duration": manageDurationToken(token)
            case "InternalNodeDuration": manageInternalDurationToken(token)
            case "LeafNodeDuration": manageLeafNodeDurationToken(token)
            case "PerformerID": managePerformerIDWithToken(token)
            case "InstrumentID": manageInstrumentIDWithToken(token)
            case "MetadataKey": manageMetadataKeyToken(token)
            case "MetadataValue": manageMetadataValueToken(token)
            default: break
            }
        }
    }
    
    // MARK: - Manage PerformerDeclaration
    
    private func managePerformerDeclarationTokenContainer(container: TokenContainer) {
        //guard let declaration = PerformerDeclarationParser.parse(container) else { return }
        //instrumentTypeModel[declaration.performerID] = declaration.instrumentTypeByID
    }
    
    // MARK: - Manage Duration
    
    private func manageDurationToken(token: Token) {
        guard let tokenDuration = token as? TokenDuration else { return }
        switch nextDurationReceivingType {
        case .Measure:
            manageExplicitDurationForNewMeasureWith(tokenDuration.duration)
        case .DurationNode:
            manageDurationForNewDurationNodeWith(tokenDuration.duration)
        }
    }
    
    private func manageExplicitDurationForNewMeasureWith(duration: Duration) {
        setDurationOfLastMeasureWith(duration)
        currentMeasureStackMode = .Explicit
    }
    
    private func incrementCurrentMeasureDurationOffsetWith(duration: Duration) {
        guard nextDurationReceivingType == .DurationNode else { return }
        currentMeasureDurationOffset += duration
    }
    
    private func setDurationOfLastMeasureWith(duration: Duration) {
        var measure = measures.removeLast()
        measure.duration = duration
        addMeasure(measure)
        incrementCurrentMeasureDurationOffsetWith(duration)
    }
    
    private func addMeasure(var measure: MeasureModel) {
        measure.number = measures.count + 1
        measures.append(measure)
    }

    private func manageDurationNodeIntervalInferringType() {
        let durationNode = DurationNodeIntervalInferring()
        durationNodeIntervalType = .Inferring
        durationNodeContainerStack.push(durationNode)
        durationNodes.append(durationNode)
        currentDurationNodeDepth = 0
    }
    
    private func manageDurationForNewDurationNodeWith(duration: Duration) {
        durationNodeIntervalType = .Enforcing
        addDurationNodeWith(duration)
    }
    
    private func addDurationNodeWith(duration: Duration) {
        let durationNode = DurationNode.with(duration)
        setOffsetDurationForNewRootDurationNode(durationNode)
        durationNodeContainerStack.push(durationNode)
        durationNodes.append(durationNode)
        currentDurationNodeDepth = 0
        accumDurationInMeasure += duration
        incrementDurationCountersForRootDurationNodeBy(duration)
    }

    // TODO: refactor
    private func setOffsetDurationForNewRootDurationNode(
        rootDurationNode: DurationNodeIntervalEnforcing
    )
    {
        let offsetDuration: Duration
        switch currentDurationNodeStackMode {
        case .Measure:
            offsetDuration = currentMeasureDurationOffset
            currentDurationNodeOffset = currentMeasureDurationOffset
        case .Increment:
            offsetDuration = currentDurationNodeOffset
        case .Decrement:
            if let lastDurationNode = durationNodeContainerStack.top
                as? DurationNodeIntervalEnforcing
            {
                offsetDuration = lastDurationNode.offsetDuration
                currentDurationNodeOffset = offsetDuration
                accumDurationInMeasure -= lastDurationNode.duration
            } else {
                offsetDuration = DurationZero
            }
        }
        rootDurationNode.offsetDuration = offsetDuration
    }
    
    private func incrementDurationCountersForRootDurationNodeBy(duration: Duration) {
        currentDurationNodeOffset += duration
    }

    // MARK: - Manage Measures
    
    private func manageMeasureToken() {
        setDurationOfLastMeasureFromContext()
        addMeasureWithOffsetDuration(currentMeasureDurationOffset)
        resetAccumDurationInMeasure()
        setMeasureAsNextReceivingType()
    }
    
    // In the case that the last Measure is to be set implicitly,
    // and therefore has a Duration of DurationZero:
    private func setDurationOfLastMeasureFromContext() {
        guard measures.count > 0 else { return }
        if measures.last?.duration == DurationZero {
            var lastMeasure = measures.removeLast()
            lastMeasure.duration = accumDurationInMeasure
            measures.append(lastMeasure)
            currentMeasureDurationOffset += accumDurationInMeasure
        } else if let lastDuration = measures.last?.duration {
            currentMeasureDurationOffset += lastDuration
        }
        
    }
    
    private func addMeasureWithOffsetDuration(offsetDuration: Duration) {
        var measure = MeasureModel(offsetDuration: offsetDuration)
        measure.number = measures.count + 1
        measures.append(measure)
    }
    
    private func resetAccumDurationInMeasure() {
        accumDurationInMeasure = DurationZero
        currentDurationNodeOffset = currentMeasureDurationOffset
    }
    
    private func setMeasureAsNextReceivingType() {
        nextDurationReceivingType = .Measure
    }
    
    private func manageNonNumericalDurationNodeModeToken() {
        durationNodeContainerStack.top?.isNumerical = false
    }
    
    private func manageNonMetricalDurationNodeModeToken() {
        durationNodeContainerStack.top?.isMetrical = false
    }
    
    private func manageNodeToken() {
        guard let pID = currentPerformerID, iID = currentInstrumentID else { return }
        let component = ComponentNode(performerID: pID, instrumentID: iID)
        addComponent(component)
    }
    
    private func manageEdgeToken() {
        guard let pID = currentPerformerID, iID = currentInstrumentID else { return }
        let component = ComponentEdge(performerID: pID, instrumentID: iID)
        addComponent(component)
    }
    
    private func manageMetadataKeyToken(token: Token) {
        currentMetadataKey = (token as? TokenString)?.value
    }
    
    private func manageMetadataValueToken(token: Token) {
        if let key = currentMetadataKey {
            if let value = (token as? TokenString)?.value {
                metadata[key] = value
                currentMetadataKey = nil
            }
        }
    }
    
    private func manageRestToken() {
        guard let pID = currentPerformerID, iID = currentInstrumentID else { return }
        let component = ComponentRest(performerID: pID, instrumentID:  iID)
        addComponent(component)
    }
    
    private func manageDurationNodeStackModeMeasure() {
        currentDurationNodeStackMode = .Measure
        accumDurationInMeasure = DurationZero
        nextDurationReceivingType = .DurationNode
    }
    
    private func manageDurationNodeStackModeIncrement() {
        currentDurationNodeStackMode = .Increment
        nextDurationReceivingType = .DurationNode
    }
    
    private func manageDurationNodeStackModeDecrement() {
        currentDurationNodeStackMode = .Decrement
        nextDurationReceivingType = .DurationNode
    }
    
    private func manageExtensionStartToken() {
        let component = ComponentExtensionStart()
        addComponent(component)
    }
    
    private func manageExtensionStopToken() {
        let component = ComponentExtensionStop()
        addComponent(component)
    }
    
    private func managePerformerIDWithToken(token: Token) {
        currentPerformerID = (token as? TokenString)?.value
    }
    
    private func manageInstrumentIDWithToken(token: Token) {
        currentInstrumentID = (token as? TokenString)?.value
    }

    private func addRootDurationNodeIntervalEnforcing() {
        let durationNode = DurationNodeIntervalEnforcing()
        durationNodes.append(durationNode)
        durationNodeContainerStack = Stack(items: [durationNode])
        currentDurationNodeDepth = 0
    }

    // TODO: refactor out duplicate code (see below)
    private func manageInternalDurationToken(token: Token) {
        if let tokenInt = token as? TokenFloat, indentationLevel = tokenInt.indentationLevel {

            let depth = depthFrom(indentationLevel)
            popDurationNodeContainersFromStackWith(depth)
            
            // guard % 1 == 0
            let beats = Int(tokenInt.value)
            if let lastDurationNode = durationNodeContainerStack.top
                as? DurationNodeIntervalEnforcing
            {
                let lastDurationNodeContainer = lastDurationNode.addChildWith(beats)
                durationNodeContainerStack.push(lastDurationNodeContainer)
                currentDurationNodeDepth = depth
            }
        }
    }
    
    private func manageLeafNodeDurationToken(token: Token) {
        if let tokenFloat = token as? TokenFloat,
            indentationLevel = tokenFloat.indentationLevel
        {
            let depth = depthFrom(indentationLevel)
            popDurationNodeContainersFromStackWith(depth)
            addDurationValueToCurrentDurationNode(value: tokenFloat.value)
        }
    }
    
    private func addDurationValueToCurrentDurationNode(value value: Float) {
        switch durationNodeContainerStack.top {
        case let currentDurationNode as DurationNodeIntervalEnforcing:
            let beats = Int(value)
            addLeafWithBeats(beats, toDurationNode: currentDurationNode)
        case let currentDurationNode as DurationNodeIntervalInferring:
            addLeafAtValue(value, toDurationNode: currentDurationNode)
        default:
            break
        }
    }
    
    private func addLeafWithBeats(beats: Int,
        toDurationNode durationNode: DurationNodeIntervalEnforcing
    )
    {
        let lastDurationNodeChild = durationNode.addChildWith(beats)
        currentDurationNodeLeaf = lastDurationNodeChild
    }
    
    private func addLeafAtValue(value: Float, toDurationNode durationNode: DurationNodeIntervalInferring
    )
    {
        let lastDurationNodeChild = durationNode.addChildAt(Duration(floatValue: value))
        currentDurationNodeLeaf = lastDurationNodeChild
    }
    
    
    private func popDurationNodeContainersFromStackWith(depth: Int) {
        if depth < currentDurationNodeDepth {
            let amount = currentDurationNodeDepth - depth
            durationNodeContainerStack.pop(amount: amount)
        }
        currentDurationNodeDepth = depth
    }
    
    private func depthFrom(indentationLevel: Int) -> Int {
        return indentationLevel - 1
    }
    
    private func manageSlurStartToken() {
        guard let pID = currentPerformerID, iID = currentInstrumentID else { return }
        let component = ComponentSlurStart(performerID: pID, instrumentID: iID)
        addComponent(component)
    }
    
    private func manageSlurStopToken() {
        guard let pID = currentPerformerID, iID = currentInstrumentID else { return }
        let component = ComponentSlurStop(performerID: pID, instrumentID: iID)
        addComponent(component)
    }
    
    private func managePitchTokenContainer(container: TokenContainer) {
        var pitches: [Float] = []
        for token in container.tokens {
            if let spannerStart = token as? TokenContainer
                where spannerStart.identifier == "SpannerStart"
            {
                // TODO: manage glissando: add glissando component
            }
            else if let tokenFloat = token as? TokenFloat {
                pitches.append(tokenFloat.value)
            }
        }
        guard let pID = currentPerformerID, iID = currentInstrumentID else { return }
        let component = ComponentPitch(performerID: pID, instrumentID: iID, values: pitches)
        addComponent(component)
    }
    
    private func manageDynamicMarkingTokenContainer(container: TokenContainer) {
        guard let pID = currentPerformerID, iID = currentInstrumentID else { return }
        for token in container.tokens {
            switch token.identifier {
            case "Value":
                let value = (token as! TokenString).value
                addDynamicMarkingComponentWithValue(value, performerID: pID, instrumentID: iID)
            case "SpannerStart":
                let component = ComponentDynamicMarkingSpannerStart(
                    performerID: pID, instrumentID: iID)
                addComponent(component)
            case "SpannerStop":
                let component = ComponentDynamicMarkingSpannerStop(
                    performerID: pID, instrumentID: iID)
                addComponent(component)
            default: break
            }
        }
    }
    
    private func addDynamicMarkingComponentWithValue(value: String,
        performerID: String, instrumentID: String
    )
    {
        let component = ComponentDynamicMarking(
            performerID: performerID,
            instrumentID: instrumentID,
            value: value
        )
        addComponent(component)
    }
    
    private func manageArticulationTokenContainer(container: TokenContainer) {
        var markings: [String] = []
        for token in container.tokens {
            if let tokenString = token as? TokenString { markings.append(tokenString.value) }
        }
        guard let pID = currentPerformerID, iID = currentInstrumentID else { return }
        let component = ComponentArticulation(performerID: pID, instrumentID: iID, values: markings)
        addComponent(component)
    }

    private func finalizeDurationNodes() {
        for durationNode in durationNodes {
            (durationNode.root as? DurationNodeIntervalEnforcing)?.matchDurationsOfTree()
            (durationNode.root as? DurationNodeIntervalEnforcing)?.scaleDurationsOfChildren()
            (durationNode.root as? DurationNodeIntervalEnforcing)?.setOffsetDurationOfChildren()
        }
    }
    
    private func addComponent(component: Component) {
        currentDurationNodeLeaf?.addComponent(component)
    }
    
    private func makeScoreModel() -> ScoreModel {
        var scoreModel = ScoreModel()
        scoreModel.metadata = metadata
        scoreModel.measures = measures
        scoreModel.durationNodes = durationNodes
        scoreModel.tempoMarkings = tempoMarkings
        scoreModel.rehearsalMarkings = rehearsalMarkings
        scoreModel.instrumentTypeModel = instrumentTypeModel
        return scoreModel
    }
}
*/