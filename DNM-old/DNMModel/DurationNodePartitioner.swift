//
//  DurationNodePartitioner.swift
//  DNMModel
//
//  Created by James Bean on 12/27/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

public class DurationNodePartitioner {
    
    // TODO
}

// TODO: Manage mutability (DurationNode went from class to struct)

/*
/**
 Partitions this DurationNode at the desired Subdivision.
 
 NYI: Less friendly partition-points. Arbitrary arrays of partition widths ([3,5,3]).
 
 - parameter newSubdivision: The Subdivision at which to partition DurationNode
 
 - returns: An array of DurationNodes, partitioned at the desired Subdivision
 */
public func partitionAtSubdivision(newSubdivision: Subdivision) -> [DurationNode] {
    matchDurationToChildren()
    assert(newSubdivision >= subdivisionOfChildren!, "can't divide by bigger subdivision")
    let ratio: Int = newSubdivision.value / subdivisionOfChildren!.value
    var multiplied: [DurationNode] = makeChildrenWithDurationsScaledByRatio(ratio)
    var compound: [[DurationNode]] = [[]]
    let sum: Int = getSumOfDurationNodes(children)
    recurseToPartitionAtSubdivision(&multiplied, compound: &compound, sum: sum)
    
    // encapsulate ----------------------------------------------------------------------->
    var partitioned: [DurationNode] = []
    for beat in compound {
        let newParent = DurationNode(duration: Duration(subdivision: newSubdivision))
        
        // TODO: manage mutability
        for child in beat { newParent.addChild(child) }
        newParent.matchDurationToChildren()
        partitioned.append(newParent)
    }
    // <----------------------------------------------------------------------- encapsulate
    
    return partitioned
}

/**
 This is the recursive counterpart to partitionAtSubdivision().
 
 - parameter array:    Array of DurationNodes
 - parameter compound: Array of Arrays of Durations, with a width prescribed by the Subdivision
 - parameter sum:      Width of each Partition
 */
public func recurseToPartitionAtSubdivision(
    inout array: [DurationNode],
    inout compound: [[DurationNode]],
    sum: Int
    ) {
        let curBeats: Int = array[0].duration.beats!.amount
        var accumulated: Int = 0
        if compound.last!.last == nil { accumulated = curBeats }
        else {
            for dur in compound.last! { accumulated += dur.duration.beats!.amount }
            accumulated += curBeats
        }
        
        if accumulated < sum {
            var newLast: [DurationNode] = compound.last!
            newLast.append(array[0])
            compound.removeLast()
            compound.append(newLast)
            array.removeAtIndex(0)
            if array.count > 0 {
                recurseToPartitionAtSubdivision(&array, compound: &compound, sum: sum)
            }
        }
        else if accumulated == sum {
            var newLast: [DurationNode] = compound.last!
            newLast.append(array[0])
            compound.removeLast()
            compound.append(newLast)
            array.removeAtIndex(0)
            if array.count > 0 {
                compound.append([])
                recurseToPartitionAtSubdivision(&array, compound: &compound, sum: sum)
            }
        }
        else {
            var newLast: [DurationNode] = compound.last!
            let endNode: DurationNode = array[0].copy()
            endNode.duration.beats!.setAmount(sum - (accumulated - curBeats))
            endNode.addComponent(ComponentExtensionStart())
            newLast.append(endNode)
            compound.removeLast()
            compound.append(newLast)
            var beginBeats = array[0].duration.beats!.amount - endNode.duration.beats!.amount
            if curBeats > sum {
                while beginBeats > sum {
                    let newNode: DurationNode = array[0].copy()
                    newNode.duration.beats!.setAmount(sum)
                    newNode.addComponent(ComponentExtensionStop())
                    newNode.addComponent(ComponentExtensionStart())
                    compound.append([newNode])
                    beginBeats -= sum
                }
            }
            if beginBeats > 0 {
                let newNode: DurationNode = array[0].copy()
                newNode.duration.beats!.setAmount(beginBeats)
                newNode.addComponent(ComponentExtensionStop())
                compound.append([newNode])
            }
            array.removeAtIndex(0)
            if array.count > 0 {
                recurseToPartitionAtSubdivision(&array, compound: &compound, sum: sum)
            }
        }
}
*/