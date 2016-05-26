//
//  DurationNodeStratumArranger.swift
//  DNM_iOS
//
//  Created by James Bean on 11/27/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit
import DNMModel

// Conform to ComponentFiltering
public struct DurationNodeStratumArranger {
    
    /// Unorganized DurationNodes that are to be arranged into DurationNodeStrata
    private var durationNodes: [DurationNode]
    
    /// The start Duration of the containing SystemModel
    private var durationOffset: Duration

    /**
    Create a DurationNodeStratumArranger

    - parameter durationNodes: DurationNodes to be arranged in DurationNodeStrata

    - returns: DurationNodeStratumArranger
    */
    public init(durationNodes: [DurationNode], durationOffset: Duration) {
        self.durationNodes = durationNodes
        self.durationOffset = durationOffset
    }
    
    // filter out the durationNodes that are to be hidden -- should this happen externally / before
    public mutating func makeDurationNodeStrataWith(componentFilters: ComponentFilters)
        -> [DurationNodeStratum]
    {
        // filter for only DurationNodes shown for a given set of ComponentFilters
        // don't do with ivar
        self.durationNodes = durationNodesShownFor(componentFilters)
        return makeDurationNodeStrata()
    }
    
    // Integrate ComponentFiltering -------------------------------------------------------->
    
    private func durationNodesShownFor(componentFilters: ComponentFilters) -> [DurationNode] {
        var resource: [DurationNode] = []
        componentFilters.forEach {
            addDurationNodesShownForComponentSpan($0, toResource: &resource)
        }
        return resource
    }
    
    
    private func addDurationNodesShownForComponentSpan(componentFilter: ComponentFilter,
        inout toResource resource: [DurationNode]
    )
    {
        componentFilter.componentTypeModel.map { $0.0 }.forEach {
            addDurationNodesShownFor($0,
                withComponentSpan: componentFilter,
                toResource: &resource
            )
        }
    }
    
    // TODO: refine this to create a masked durationNode for partially shown durationNodes
    private func addDurationNodesShownFor(performerID: PerformerID,
        withComponentSpan componentFilter: ComponentFilter,
        inout toResource resource: [DurationNode]
    )
    {
        if rhythmShownFor(performerID, inComponentSpan: componentFilter) {
            addDurationNodesWithPerformerID(performerID,
                inDurationInterval: componentFilter.durationInterval,
                toResource: &resource
            )
        }
    }
    
    private func addDurationNodesWithPerformerID(performerID: PerformerID,
        inDurationInterval durationInterval: DurationInterval,
        inout toResource resource: [DurationNode]
    )
    {
        // filter durationNodes for those that fit within duration interval, and correct pid
        durationNodes.filter {
            durationNode($0,
                isInDurationInterval: durationInterval,
                andHasComponentWithPerformerID: performerID
            )
        }.forEach { if !resource.containsObject($0) { resource.append($0) } }
    }
    
    private func durationNode(durationNode: DurationNode,
        isInDurationInterval durationInterval: DurationInterval,
        andHasComponentWithPerformerID performerID: PerformerID
    ) -> Bool
    {
        let hasComponentWithPerformerID = durationNode.hasComponentWithPerformerID(performerID)
        let isInDurationInterval = durationInterval.intersectsWith(durationNode)
        return hasComponentWithPerformerID && isInDurationInterval
    }
    
    private func rhythmShownFor(performerID: PerformerID,
        inComponentSpan componentFilter: ComponentFilter
    ) -> Bool
    {
        return componentFilter.componentTypeModel[performerID]?["rhythm"] == .Show
    }
    
    // < refactor to ComponentFiltering -------------------------------------------------------
    
    /**
    Arrange DurationNodes into DurationNodeStrata

    - returns: DurationNodeStrata
    */
    public func makeDurationNodeStrata() -> [DurationNodeStratum] {
        let durationNodeStratumClusters = makeDurationNodeStratumClusters()
        let durationNodeStrata = recombineStratumClusters(durationNodeStratumClusters)
        return durationNodeStrata
    }

    private func recombineStratumClusters(var stratumClusters: [DurationNodeStratum])
        -> [DurationNodeStratum]
    {
        var s_index0: Int = 0
        while s_index0 < stratumClusters.count {
            var s_index1: Int = 0
            while s_index1 < stratumClusters.count {
                let s0 = stratumClusters[s_index0]
                let s1 = stratumClusters[s_index1]
                if !stratum(s0, overlapsWithStratum: s1) {
                    let s0_pids: [String] = performerIDsInStratum(s0).unique()
                    let s1_pids: [String] = performerIDsInStratum(s1).unique()
                    if s0_pids == s1_pids {
                        let concatenated = s0 + s1
                        stratumClusters.removeAtIndex(s_index0)
                        stratumClusters.removeAtIndex(s_index1 - 1) // compensate for above
                        stratumClusters.insert(concatenated, atIndex: 0)
                        s_index0 = 0
                        s_index1 = 0
                    }
                    else { s_index1++ } // how do i clump these together?
                }
                else { s_index1++ } // see above!
            }
            s_index0++
        }
        return stratumClusters
    }
    
    // Encapsulate into DurationNodeStratumClusterFactory
    private func makeDurationNodeStratumClusters() -> [DurationNodeStratum] {
        // First pass: get initial stratum clumps
        var stratumClumps: [DurationNodeStratum] = []
        durationNodeLoop: for durationNode in durationNodes {
            
            // Create initial stratum if none yet
            if stratumClumps.count == 0 {
                stratumClumps = [
                    DurationNodeStratum(
                        durationNode: durationNode,
                        systemDurationOffset: durationOffset
                    )
                ]
                continue durationNodeLoop
            }
            
            // Find if we can clump the remaining durationNodes onto a stratum
            var matchFound: Bool = false
            stratumLoop: for s in 0..<stratumClumps.count {
                
                let durationIntervals = stratumClumps[s].map { $0.durationInterval }
                
                let stratum_durationInterval = DurationInterval.unionWithDurationIntervals(
                    durationIntervals
                )
                
                let relationship: IntervalRelationship = durationNode.durationInterval.relationshipToDurationInterval(stratum_durationInterval)
                
                // find if DurationNodeStrata are adjactent and can be rejoined
                if relationship == .Meets {
                    var stratum = stratumClumps[s]
                    let stratum_pids = performerIDsInStratum(stratum)
                    let dn_pids = performerIDsInDurationNode(durationNode)
                    for pid in dn_pids {
                        if stratum_pids.contains(pid) {
                            stratumClumps.removeAtIndex(s)
                            stratum.durationNodes.append(durationNode)
                            stratumClumps.insert(stratum, atIndex: s)
                            matchFound = true
                            break stratumLoop
                        }
                    }
                }
            }
            if !matchFound {
                stratumClumps.append(
                    DurationNodeStratum(
                        durationNode: durationNode,
                        systemDurationOffset: durationOffset
                    )
                )
            }
        }
        return stratumClumps
    }
    
    private func stratum(stratum: DurationNodeStratum,
        overlapsWithStratum otherStratum: DurationNodeStratum
    ) -> Bool
    {
        for dn0 in stratum {
            for dn1 in otherStratum {
                if dn0.durationInterval.intersectsWith(dn1.durationInterval) { return true }
            }
        }
        return false
    }

    private func performerIDsInStratum(stratum: DurationNodeStratum) -> [String] {
        // use reduce
        var performerIDs: [String] = []
        for dn in stratum { performerIDs += performerIDsInDurationNode(dn) }
        return performerIDs
    }
    
    private func performerIDsInDurationNode(durationNode: DurationNode) -> [String] {
        return Array<String>(durationNode.instrumentIDsByPerformerID.keys)
    }
}

public typealias BeamGroupViewModelStratum = [BeamGroupViewModel]