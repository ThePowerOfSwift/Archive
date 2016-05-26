//
//  DurationNodeIntervalEnforcingDurationMatcher.swift
//  DNMModel
//
//  Created by James Bean on 1/18/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public class DurationNodeIntervalEnforcingDurationMatcher {
    
    private let durationNode: DurationNodeIntervalEnforcing
    
    public init(durationNode: DurationNodeIntervalEnforcing) {
        self.durationNode = durationNode
    }
    
    // Matches the durations of the entire DurationNode tree of which this Node is a part
    public func matchDurationsOfTree() {
        guard var root = durationNode.root as? DurationNodeIntervalEnforcing  else { return }
        traverseToMatchDurationsOfTree(&root)
    }
    
    private func traverseToMatchDurationsOfTree(inout node: DurationNodeIntervalEnforcing) {
        if node.isContainer {
            node.matchParentDurationToChildren()
            (node.children as? [DurationNodeIntervalEnforcing])?.forEach {
                var child = $0
                traverseToMatchDurationsOfTree(&child)
            }
        }
    }
    
    // TODO: implement reduction for all evens relative durations + beats
    // -- e.g.: (4,2,2,4) in 14: should be (2,1,1,2) in 7
    public func matchDurationOfDurationNodeToChildren() {
        guard let reduced = reducedRelativeDurationValues() else { return }
        respellDurationsOfChildrenAccordingToParentSubdivision()
        respellDurationsWith(reduced)
        setBeatsOfChildrenWith(reduced)
    }
    
    private func reducedRelativeDurationValues() -> [Int]? {
        guard let relativeDurs = durationNode.relativeDurationsOfChildren else { return nil }
        return relativeDurs.map { $0 / relativeDurs.greatestCommonDivisor()! }
    }
    
    private func respellDurationsOfChildrenAccordingToParentSubdivision() {
        (durationNode.children as? [DurationNodeIntervalEnforcing])?.forEach {
            $0.duration.respellAccordingToSubdivision(durationNode.duration.subdivision!)
        }
    }
    
    private func respellDurationsWith(reduced: [Int]) {
        let sum: Int = reduced.sum()
        let beats = durationNode.duration.beats!.amount
        if sum < beats {
            respellDurationsOfChildrenWithValuesIn(reduced)
        } else if sum > beats {
            respellDurationsToMatchBeats(beats, andSum: sum)
        }
    }
    
    private func respellDurationsOfChildrenWithValuesIn(reduced: [Int]) {
        (durationNode.children as? [DurationNodeIntervalEnforcing])?.enumerate().forEach {
            let reducedBeats = reduced[$0.index]
            $0.element.duration.respellAccordingToBeats(reducedBeats)
        }
    }
    
    private func setBeatsOfChildrenWith(reduced: [Int]) {
        (durationNode.children as? [DurationNodeIntervalEnforcing])?.enumerate().forEach {
            let reducedBeats = reduced[$0.index]
            $0.element.duration.setBeats(reducedBeats)
        }
    }
   
    private func respellDurationsToMatchBeats(beats: Int, andSum sum: Int) {
        respellParentDurationToMatchBeats(beats, andSum: sum)
        setSubdivisionOfChildrenTo(durationNode.duration.subdivision!)
    }
    
    private func respellParentDurationToMatchBeats(beats: Int, andSum sum: Int) {
        let closestPowerOfTwo = closestPowerOfTwoForBeats(beats, andSum: sum)
        let scale: Int = closestPowerOfTwo / beats
        let newBeats = durationNode.duration.beats!.amount * scale
        durationNode.duration.respellAccordingToBeats(newBeats)
    }
    
    private func setSubdivisionOfChildrenTo(subdivision: Subdivision) {
        (durationNode.children as? [DurationNodeIntervalEnforcing])?.forEach {
            $0.duration.setSubdivision(subdivision)
        }
    }
    
    private func closestPowerOfTwoForBeats(beats: Int, andSum sum: Int) -> Int {
        return closestPowerOfTwo(multiplier: beats, value: sum)
    }
}