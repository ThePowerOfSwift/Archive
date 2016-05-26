//
//  ComponentNodeSorter.swift
//  DNM_iOS
//
//  Created by James Bean on 12/22/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation
import DNMModel

public class ComponentNodeSorter {
    
    private let viewerProfile: ViewerProfile
    private let sortedPerformerIDs: [PerformerID]
    
    private let beamGroupStrataByPerformerID: [PerformerID: [BeamGroupStratum]]
    private let performerStratumByPerformerID: [PerformerID: PerformerStratum]
    private let dynamicMarkingStratumByPerformerID: [PerformerID: DynamicMarkingStratum]
    private let labelStratumByPerformerID: [PerformerID: LabelStratum]
    
    public init(
        viewerProfile: ViewerProfile,
        sortedPerformerIDs: [PerformerID],
        beamGroupStrataByPerformerID: [PerformerID: [BeamGroupStratum]] = [:],
        performerStratumByPerformerID: [PerformerID: PerformerStratum] = [:],
        dynamicMarkingStratumByPerformerID: [PerformerID: DynamicMarkingStratum] = [:],
        labelStratumByPerformerID: [PerformerID: LabelStratum] = [:]
    )
    {
        self.viewerProfile = viewerProfile
        self.sortedPerformerIDs = sortedPerformerIDs // or should this happen in here?
        self.beamGroupStrataByPerformerID = beamGroupStrataByPerformerID
        self.performerStratumByPerformerID = performerStratumByPerformerID
        self.dynamicMarkingStratumByPerformerID = dynamicMarkingStratumByPerformerID
        self.labelStratumByPerformerID = labelStratumByPerformerID
    }
    
    public func makeSortedComponentNodes() -> [ViewNode] {
        return sortedPerformerIDs.reduce([]) { $0 + sortedComponentNodesFor($1) }
    }
    
    private func sortedComponentNodesFor(performerID: PerformerID) -> [ViewNode] {
        switch performerID {
        case viewerProfile.viewer.identifier:
            return sortedComponentNodesForCurrentViewer(performerID)
        default:
            return sortedComponentNodesForPeer(performerID)
        }
    }

    private func sortedComponentNodesForCurrentViewer(performerID: PerformerID) -> [ViewNode] {
        var sortedNodes: [ViewNode] = []
        if let label = labelStratumByPerformerID[performerID] { sortedNodes.append(label) }
        if let perf = performerStratumByPerformerID[performerID] { sortedNodes.append(perf) }
        beamGroupStrataByPerformerID[performerID]?.forEach { sortedNodes.append($0) }
        if let dyn = dynamicMarkingStratumByPerformerID[performerID] { sortedNodes.append(dyn) }
        return sortedNodes
    }

    private func sortedComponentNodesForPeer(performerID: PerformerID) -> [ViewNode] {
        var sortedNodes: [ViewNode] = []
        beamGroupStrataByPerformerID[performerID]?.forEach { sortedNodes.append($0) }
        if let perf = performerStratumByPerformerID[performerID] { sortedNodes.append(perf) }
        if let label = labelStratumByPerformerID[performerID] { sortedNodes.append(label) }
        if let dyn = dynamicMarkingStratumByPerformerID[performerID] { sortedNodes.append(dyn) }
        return sortedNodes
    }
}