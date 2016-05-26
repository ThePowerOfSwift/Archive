//
//  DurationNode.swift
//  DNMModel
//
//  Created by James Bean on 8/11/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

/**
DurationNode is a hierarchical structure with an accompanying datum of Duration
*/
public class DurationNode: Node, DurationSpanning {
    
    // MARK: Attributes
    
    // TODO: clarify duration / offsetDuration / durationInterval relationship

    /// DurationInterval of DurationNode
    public var durationInterval: DurationInterval { return DurationIntervalZero }
    
    /// Components contained by DurationNode
    public var components: [Component] = []
    
    // wrap into own class: ComponentOrganizer
    // TODO: Implement
    public var componentModel: ComponentModel {
        return ComponentOrganizer(components: components).componentModel
    }
    
    public var isRest: Bool { return getIsRest() }

    /// All Instrument ID values organized by Performer ID keys
    public var instrumentIDsByPerformerID: [String : [String]] { get { return getIIDsByPID() } }
    
    /// If this DurationNode is a continuation from another ("tied")
    public var hasExtensionStart: Bool { return getHasExtensionStart() }
    
    /// If this DurationNode continues into another ("tied")
    public var hasExtensionStop: Bool { return getHasExtensionStop() }
    
    // TODO: change to showsMetrics
    /// If this DurationNode shall be represented with metrical beaming
    public var isMetrical: Bool = true
    
    // TODO: change to showsNumerics
    /** 
    If this DurationNode is either [1] subdividable (non-tuplet), or [2] should not be
    represented with tuplet bracket(s).
    */
    public var isNumerical: Bool = true // only applies to root duration nodes
    
    public var rhythmEnabled: Bool = true
    
    /// If this DurationNode has only Extension Components (ties) (not a rest, but no info).
    public var hasOnlyExtensionComponents: Bool { return getHasOnlyExtensionComponents() }
    
    public var componentTypesByPerformerID: [PerformerID: [ComponentType]] {
        return getComponentTypesByPerformerID()
    }
    
    // MARK: Analyze DurationNode
    
    /// Array of integers with reduced relative durations of children
    public var relativeDurationsOfChildren: [Int]? {
        get { return getRelativeDurationsOfChildren() }
    }
    
    /// The reduced, leveled Subdivision of children
    public var subdivisionOfChildren: Subdivision? {
        get { return getSubdivisionOfChildren() }
    }
    
    /// Scale of children DurationNodes
    public var scaleOfChildren: Float? { get { return getScaleOfChildren() } }
    
    /// If DurationNode is subdividable (non-tuplet)
    public var isSubdividable: Bool { get { return getIsSubdividable() } }
    
    // MARK: - Create a DurationNode
    
    public class func with(durationInterval: DurationInterval)
        -> DurationNodeIntervalEnforcing
    {
        return DurationNodeIntervalEnforcing(durationInterval: durationInterval)
    }
    
    public class func with(beats: Int, _ subdivisionValue: Int)
        -> DurationNodeIntervalEnforcing
    {
        return DurationNodeIntervalEnforcing(duration: Duration(beats, subdivisionValue))
    }
    
    public class func with(
        duration: Duration = DurationZero,
        offsetDuration: Duration = DurationZero,
        sequence: NSArray = []
    ) -> DurationNodeIntervalEnforcing
    {
        return DurationNodeIntervalEnforcing(
            duration: duration, offsetDuration: offsetDuration, sequence: sequence
        )
    }
    
    public override init() {
        super.init()
    }
    
    public func hasComponentWithPerformerID(performerID: PerformerID) -> Bool {
        return instrumentIDsByPerformerID.keys.contains(performerID)
    }
    
    public func hasComponentWithType(type: ComponentType) -> Bool {
        if isContainer { return false }
        for component in components { if component.type == type { return true } }
        return false
    }
    
    public func hasComponentWithIdentifier(identifier: String) -> Bool {
        if isContainer { return false }
        for component in components { if component.identifier == identifier { return true } }
        return false
    }
    
    
    public func addComponent(component: Component) {
        components.append(component)
    }
    
    public func clearComponents() {
        components = []
    }
    
    // MARK: Operations

    /**
    Copy DurationNode LEAF with Components for specified PerformerID and InstrumentID
    
    - parameter performerID:  PerformerID
    - parameter instrumentID: InstrumentID
    
    - returns: DurationNode with Components for specified PerformerID and InstrumentID
    */
    public func copyWithComponentsFor(instrumentIdentifierPath: InstrumentIdentifierPath)
        -> DurationNode
    {
        let matchingComponents = componentsMatching(instrumentIdentifierPath)
        let newDurationNode = DurationNodeIntervalEnforcing(durationInterval: durationInterval)
        newDurationNode.components = matchingComponents
        return newDurationNode
    }
    
    private func componentsMatching(instrumentIdentifierPath: InstrumentIdentifierPath)
        -> [Component]
    {
        return components.filter { $0.instrumentIdentifierPath == instrumentIdentifierPath }
    }
    
    public override func childAt(index: Int) -> DurationNode? {
        return super.childAt(index) as? DurationNode
    }
    
    public override func leafAt(index: Int) -> DurationNode? {
        return super.leafAt(index) as? DurationNode
    }
    
    /**
    Deep copy of DurationNode. A new DurationNode is created with all attributes equivalant
    to original.
    When comparing a Node that has been copied from another,"===" will return false,
    while "==" will return true (NYI).
    
    - returns: DurationNode object
    */
    public override func copy() -> DurationNode {
        var node: Node = self
        descendToCopy(&node)
        return node as! DurationNode
    }
    
    /**
    This is the recursive counterpart to copy(). This method copies the Duration of each
    child and descends to each child, if applicable.
    
    - parameter node: Node
    */
    public override func descendToCopy(inout node: Node) {
        guard var node = node as? DurationNode else { return }
        let newParent = DurationNodeIntervalEnforcing(durationInterval: node.durationInterval)
        newParent.components = node.components
        if node.isContainer {
            for child in node.children {
                var newChild: Node = child
                descendToCopy(&newChild)
                newParent.addChild(newChild)
            }
        }
        node = newParent
    }
    
    /*
    /**
    - returns: Maximum Subdivision of children of this DurationNode, if present.
    */
    public func getMaximumSubdivisionOfChildren() -> Subdivision? {
        if isContainer {
            var maxSubdivision: Subdivision?
            for child in children {
                let durNodeChild = child as! DurationNode
                if (
                    maxSubdivision == nil ||
                        durNodeChild.duration.subdivision! > maxSubdivision!
                    )
                {
                    maxSubdivision = durNodeChild.duration.subdivision!
                }
            }
            return maxSubdivision
        }
        else { return nil }
    }
    */
    
    // TODO: refactor to IntervalEnforcing
    /**
    - returns: An array of integers of relative amounts of Beats in the Durations of children.
    */
    public func getRelativeDurationsOfChildren() -> [Int]? {
        if !isContainer { return nil }
        var relativeDurations: [Int] = []
        for child in children as! [DurationNodeIntervalEnforcing] {
            let child_copy = child.copy()
            child_copy.duration.respellAccordingToSubdivision(durationInterval.duration.subdivision!)
            relativeDurations.append(child_copy.duration.beats!.amount)
        }
        
        return relativeDurations
    }
    
    /**
    Checks if the sum of the Durations of all children DurationNodes are equivelant to the
    amount of Beats in this DurationNode. Otherwise, this DurationNode is a tuplet.
    
    - returns: If this DurationNode is subdividable
    */
    public func getIsSubdividable() -> Bool {
        let sum: Int = relativeDurationsOfChildren!.sum()
        let beats: Int = durationInterval.duration.beats!.amount
        return sum == beats
    }
    
    
    private func getIsRest() -> Bool {
        if !isLeaf { return false }
        for component in components { if component is ComponentRest { return true } }
        return false
    }
    
    /**
    - returns: Subdivision of children, if present.
    */
    public func getSubdivisionOfChildren() -> Subdivision? {
        if !isContainer { return nil }
        return (children[0] as! DurationNodeIntervalEnforcing).duration.subdivision!
    }
    
    private func getScaleOfChildren() -> Float {
        return (children as! [DurationNodeIntervalEnforcing]).first!.duration.scale
    }
    
    /*
    // TODO: make static, private
    /**
    - parameter durationNodes: Array of DurationNodes
    
    - returns: Sum of the Beats in the Durations of each DurationNode in array.
    */
    public func getSumOfDurationNodes(durationNodes: [DurationNode]) -> Int {
        var sum: Int = 0
        for child in durationNodes { sum += child.duration.beats!.amount }
        return sum
    }
    */
    

    private func getComponentTypesByPerformerID() -> [PerformerID: [ComponentType]] {
        var componentTypesByPerformerID: [PerformerID: [ComponentType]] = [:]
        func addComponentTypesForDurationNode(durationNode: DurationNode) {
            for component in durationNode.components {
                componentTypesByPerformerID.safelyAndUniquelyAppend("performer",
                    toArrayWithKey: component.instrumentIdentifierPath.performerID
                )
                componentTypesByPerformerID.safelyAndUniquelyAppend(component.type,
                    toArrayWithKey: component.instrumentIdentifierPath.performerID
                )
            }
        }
        
        switch self.isLeaf {
        case true:
            addComponentTypesForDurationNode(self)
        case false:
            (leaves as? [DurationNode])?.forEach { addComponentTypesForDurationNode($0) }
        }
        
        return componentTypesByPerformerID
    }
    
    private func getIIDsByPID() -> [String : [String]] {
        var iIDsByPID: [String : [String]] = [:]
        let durationNode = self
        descendToGetIIDsByPID(durationNode: durationNode, iIDsByPID: &iIDsByPID)
        return iIDsByPID
    }
    
    // FIXME
    private func descendToGetIIDsByPID(
        durationNode durationNode: DurationNode,
        inout iIDsByPID: [String : [String]]
    )
    {
        func addInstrumentID(
            iID: String,
            andPerformerID pID: String,
            inout toIIDsByPID iIDsByPID: [String : [String]]
        )
        {
            if iIDsByPID[pID] == nil { iIDsByPID[pID] = [iID] }
            else if !iIDsByPID[pID]!.contains(iID) { iIDsByPID[pID]!.append(iID) }
        }
        
        for component in durationNode.components {
            addInstrumentID(component.instrumentIdentifierPath.instrumentID,
                andPerformerID: component.instrumentIdentifierPath.performerID,
                toIIDsByPID: &iIDsByPID
            )
        }
        if durationNode.isContainer {
            for child in durationNode.children as! [DurationNode] {
                descendToGetIIDsByPID(durationNode: child, iIDsByPID: &iIDsByPID)
            }
        }
    }
    
    private func getHasExtensionStart() -> Bool {
        for component in components {
            if component is ComponentExtensionStart { return true }
        }
        return false
    }
    
    private func getHasExtensionStop() -> Bool {
        for component in components {
            if component is ComponentExtensionStop { return true }
        }
        return false
    }
    
    
    private func getHasOnlyExtensionComponents() -> Bool {
        for component in components {
            if !(component is ComponentExtensionStart) && !(component is ComponentExtensionStop) {
                return false
            }
        }
        return true
    }
    
    // MARK: - Add Components
    
    public func slur(startIndex: Int, _ stopIndex: Int) {
        if let startLeaf = leafAt(startIndex), stopLeaf = leafAt(stopIndex) {
            startLeaf += ComponentSlurStart()
            stopLeaf += ComponentSlurStop()
        }
    }
    
    public func extend(index: Int) {
        if let leaf = leafAt(index) { leaf += ComponentExtensionStart() }
    }
    
    public func extendLast() {
        if let leaf = leaves.last as? DurationNode { leaf += ComponentExtensionStart() }
    }
    
    public override func getDescription() -> String {
        var description: String = "DurationNode"
        if isRoot { description += " (root)" }
        else if isLeaf { description = "leaf" }
        else { description = "internal" }
        
        // add duration info : make this DurationSpan
        description += ": \(durationInterval)"
        
        if isRest { description += " (rest)" }
        // add component info
        if components.count > 0 {
            description += ": "
            for (c, component) in components.enumerate() {
                if c > 0 { description += ", " }
                description += "\(component)"
            }
            description += ";"
        }
        
        // traverse children
        if isContainer {
            for child in children {
                description += "\n"
                for _ in 0..<child.depth { description += "\t" }
                description += "\(child)"
            }
        }
        return description
    }
    
    public subscript(index: Int) -> DurationNode? {
        return leafAt(index)
    }
}

public func += (lhs: DurationNode, rhs: Component) {
    lhs.addComponent(rhs)
}

public func += (lhs: DurationNode, rhs: [Component]) {
    rhs.forEach { lhs.addComponent($0) }
}

public func == (lhs: DurationNode, rhs: DurationNode) -> Bool {
    return lhs.durationInterval == rhs.durationInterval &&
        lhs.components == rhs.components &&
        lhs.children == rhs.children
}