//
//  DurationNodeIntervalEnforcing.swift
//  DNMModel
//
//  Created by James Bean on 1/18/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public class DurationNodeIntervalEnforcing: DurationNode {

    public var duration: Duration = DurationZero
    public var offsetDuration: Duration = DurationZero
    
    public override var durationInterval: DurationInterval {
        return DurationInterval(duration: duration, startDuration: offsetDuration)
    }
    
    // MARK: - Create a DurationNodeIntervalEnforcing
    
    public init(durationInterval: DurationInterval) {
        super.init()
        self.duration = durationInterval.duration
        self.offsetDuration = durationInterval.startDuration
    }

    public init(
        duration: Duration = DurationZero,
        offsetDuration: Duration = DurationZero,
        sequence: NSArray = []
    )
    {
        super.init()
        self.duration = duration
        self.offsetDuration = offsetDuration
        addChildrenWithSequence(sequence)
    }
    
    func addChildWith(beats: Int) -> DurationNodeIntervalEnforcing {
        let child = DurationNode.with(beats, duration.subdivision!.value)
        addChild(child)
        cleanChildren()
        return child
    }
    
    public override func copy() -> DurationNodeIntervalEnforcing {
        return super.copy() as! DurationNodeIntervalEnforcing
    }
    
    /**
    Add child nodes with relative durations in sequence.

    - parameter sequence: Sequence of relative durations of child nodes

    - returns: DurationNode object
    */
    public func addChildrenWithSequence(sequence: NSArray) {
        traverseToAddChildrenWith(sequence, parent: self)
        cleanChildren()
    }

    private func traverseToAddChildrenWith(sequence: NSArray,
        parent: DurationNodeIntervalEnforcing
    )
    {
        for el in sequence {
            if let leafBeats = el as? Int {
                let leafNode = DurationNode.with(abs(leafBeats), duration.subdivision!.value)
                parent.addChild(leafNode)
            }
            else if let container = el as? NSArray {
                var node: DurationNodeIntervalEnforcing?
                if let beats = container[0] as? Int {
                    node = DurationNode.with(beats, duration.subdivision!.value)
                    parent.addChild(node!)
                }
                if let seq = container[1] as? NSArray {
                    traverseToAddChildrenWith(seq, parent: node!)
                }
            }
        }
    }
    
    private func cleanChildren() {
        matchDurationsOfTree()
        (root as? DurationNodeIntervalEnforcing)?.scaleDurationsOfChildren()
        setSubdivisionOfSingleChildIfNecessary(subdivision: duration.subdivision!)
        setOffsetDurationOfChildren()
    }
    
    public func matchDurationsOfTree() {
        let durationMatcher = DurationNodeIntervalEnforcingDurationMatcher(durationNode: self)
        durationMatcher.matchDurationsOfTree()
    }
    
    // TODO: refactor to own class
    
    /**
     Recursively scales the Durations of all Nodes in a DurationNode tree. This scale is used
     when calculating the graphical widths and temporal lengths of (embedded-)tuplet rhythms.
     */
    public func scaleDurationsOfChildren() {
        var node: DurationNodeIntervalEnforcing = self
        var scale: Float = duration.scale
        descendToScaleDurationsOfChildren(&node, scale: &scale)
    }
    
    /**
     This is the recursive counterpart to scaleDurationsOfChildren(). This method sets the
     inheritedScale of the Duration of each Node in a DurationNode tree.
     
     - parameter node:  DurationNode to be scaled
     - parameter scale: Amount by which to scale Duration of DurationNode
     */
    public func descendToScaleDurationsOfChildren(
        inout node: DurationNodeIntervalEnforcing, inout scale: Float
    )
    {
        node.duration.setScale(scale)
        if node.isContainer {
            let beats: Float = Float(node.duration.beats!.amount)
            let sumAsInt: Int = node.relativeDurationsOfChildren!.sum()
            let sum: Float = Float(sumAsInt)
            var newScale = scale * (beats / sum)
            for child in node.children as! [DurationNodeIntervalEnforcing] {
                var child = child
                descendToScaleDurationsOfChildren(&child, scale: &newScale)
            }
        }
    }
    
    private func setSubdivisionOfSingleChildIfNecessary(subdivision subdivision: Subdivision) {
        guard children.count == 1 else { return }
        guard let firstChild = children.first as? DurationNodeIntervalEnforcing else { return }
        firstChild.duration.setSubdivision(subdivision)
    }
    
    public func scaleDurationsOfTree(scale scale: Float) -> DurationNode {
        duration.setScale(scale)
        scaleDurationsOfChildren()
        return self
    }
    
    public func matchParentDurationToChildren() {
        let durationMatcher = DurationNodeIntervalEnforcingDurationMatcher(durationNode: self)
        durationMatcher.matchDurationOfDurationNodeToChildren()
    }
    
    /**
    Levels and Reduces the Durations of all of the children of this DurationNode, if present.
    */
    public func matchDurationsOfChildren() {
        reduceDurationsOfChildren()
    }
    
    /**
    Ensures that the Durations of each child of this DurationNode have the same Subdivision.
    */
    public func levelDurationsOfChildren() {
        if !isContainer { return }
        guard let children = children as? [DurationNodeIntervalEnforcing] else { return }
        levelDurationsOfSequence(children)
    }
    
    /**
    Ensures that the Durations of each child, once leveled, are reduced to the greatest degree.
    */
    public func reduceDurationsOfChildren() {
        if !isContainer { return }
        guard let children = children as? [DurationNodeIntervalEnforcing] else { return }
        levelDurationsOfSequence(children)
        reduceDurationsOfSequence(children)
    }
    
    /**
    - parameter ratio: Amount by which to scale the Durations of the children of this DurationNode
    
    - returns: An array of DurationNodes with Durations scaled by ratio
    */
    public func makeChildrenWithDurationsScaledByRatio(ratio: Int) -> [DurationNodeIntervalEnforcing] {
        var multiplied: [DurationNodeIntervalEnforcing] = []
        for child in children as! [DurationNodeIntervalEnforcing] {
            let newChild: DurationNodeIntervalEnforcing = child.copy()
            let newBeats = newChild.duration.beats! * ratio * duration.beats!.amount
            newChild.duration.setBeats(newBeats)
            newChild.duration.subdivision! *= closestPowerOfTwo(
                multiplier: 2, value: newChild.duration.beats!.amount
            ) * ratio
            multiplied.append(newChild)
        }
        return multiplied
    }

    private func traverseToSetOffsetDurationOfChildrenOf(
        durationNode: DurationNodeIntervalEnforcing,
        inout andOffsetDuration offsetDuration: Duration
    )
    {
        durationNode.offsetDuration = offsetDuration
        
        (durationNode.children as? [DurationNodeIntervalEnforcing])?.forEach {
            var newOffsetDuration = offsetDuration
            if $0.isContainer {
                traverseToSetOffsetDurationOfChildrenOf($0,
                    andOffsetDuration: &newOffsetDuration
                )
            }
            else { $0.offsetDuration = offsetDuration }
            offsetDuration += $0.duration
        }
    }
    
    public func setOffsetDurationOfChildren() {
        var offsetDuration = self.offsetDuration
        traverseToSetOffsetDurationOfChildrenOf(self, andOffsetDuration: &offsetDuration)
    }
}



public func += (durationNode: DurationNodeIntervalEnforcing, beats: Int) {
    durationNode.addChildWith(beats)
}

public func += (durationNode: DurationNodeIntervalEnforcing, relativeDurations: [Int]) {
    durationNode.addChildrenWithSequence(relativeDurations)
}
