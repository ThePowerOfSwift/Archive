//
//  DurationNodeIntervalEnforcingSequence.swift
//  DNMModel
//
//  Created by James Bean on 1/19/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public func matchDurationsOfSequence(sequence: [DurationNodeIntervalEnforcing]) {
    levelDurationsOfSequence(sequence)
    reduceDurationsOfSequence(sequence)
}

public func levelDurationsOfSequence(sequence: [DurationNodeIntervalEnforcing]) {
    let maxSubdivision: Subdivision = getMaximumSubdivisionOfSequence(sequence)!
    sequence.forEach { $0.duration.respellAccordingToSubdivision(maxSubdivision) }
}

public func reduceDurationsOfSequence(sequence: [DurationNodeIntervalEnforcing]) {
    levelDurationsIfHeterogeneousSubdivisionsIn(sequence)
    let gcd: Int = getRelativeDurationsOfSequence(sequence).greatestCommonDivisor()!
    respellNodesIn(sequence, withGreatestCommonDenominator: gcd)
}

public func respellNodesIn(sequence: [DurationNodeIntervalEnforcing],
    withGreatestCommonDenominator gcd: Int
)
{
    sequence.forEach { $0.duration.respellAccordingToBeats($0.duration.beats! / gcd) }
}

public func allSubdivisionsOfSequenceAreEquivalent(sequence: [DurationNodeIntervalEnforcing])
    -> Bool
{
    if sequence.count == 0 { return false }
    let refSubdivision = sequence.first!.duration.subdivision!
    for i in 1..<sequence.count {
        if sequence[i].duration.subdivision! != refSubdivision { return false }
    }
    return true
}

public func getRelativeDurationsOfSequence(sequence: [DurationNodeIntervalEnforcing]) -> [Int] {
    let sequenceCopy = sequence.map { $0.copy() }
    levelDurationsIfHeterogeneousSubdivisionsIn(sequenceCopy)
    let relativeDurations = sequenceCopy.map { $0.duration.beats!.amount }
    return relativeDurations
}

public func levelDurationsIfHeterogeneousSubdivisionsIn(
    sequence: [DurationNodeIntervalEnforcing]
)
{
    if !allSubdivisionsOfSequenceAreEquivalent(sequence) { levelDurationsOfSequence(sequence) }
}

// TODO: refactor out of here
public func getMaximumSubdivisionOfSequence(sequence: [DurationNodeIntervalEnforcing])
    -> Subdivision?
{
    return sequence.map { $0.duration.subdivision! }.maxElement()
}

func getMinimumSubdivisionOfSequence(sequence: [DurationNodeIntervalEnforcing])
    -> Subdivision?
{
    return sequence.map { $0.duration.subdivision! }.minElement()
}