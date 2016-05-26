//
//  LabelStratumModelArranger.swift
//  DNMModel
//
//  Created by James Bean on 1/29/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public class LabelStratumModelArranger: ComponentFiltering {
    
    public let durationNodes: [DurationNode]
    
    public init(durationNodes: [DurationNode]) {
        self.durationNodes = durationNodes
    }
    
    public func makeLabelStratumModels() -> [LabelStratumModel] {
        var leaves = durationNodes.map { $0.copy() }
        leaves = leavesFrom(leaves, withComponentIdentifier: "Label")
        print("leaves with label: \(leaves)")
        let leavesByPerformerID = organizeLeavesByPerformerID(leaves: leaves)
        print("leaves by pid: \(leavesByPerformerID)")
        return makeStrataWith(leavesByPerformerID)
    }
    
    private func organizeLeavesByPerformerID(leaves leaves: [DurationNode])
        -> [PerformerID: [DurationNode]]
    {
        var leavesByPerformerID: [PerformerID: [DurationNode]] = [:]
        for leaf in leaves {
            guard let pID = leaf.components.first?.instrumentIdentifierPath.performerID else {
                continue
            }
            leavesByPerformerID.safelyAndUniquelyAppend(leaf, toArrayWithKey: pID)
        }
        return leavesByPerformerID
    }
    
    private func makeStrataWith(leavesByPerformerID: [PerformerID: [DurationNode]])
        -> [LabelStratumModel]
    {
        var strata: [LabelStratumModel] = []
        for (pID, leaves) in leavesByPerformerID {
            var stratum = LabelStratumModel(identifier: pID)
            leaves.forEach { addLabelModelFrom($0, toStratum: &stratum) }
            strata.append(stratum)
        }
        return strata
    }
    
    private func addLabelModelFrom(leaf: DurationNode,
        inout toStratum stratum: LabelStratumModel
    )
    {
        guard let labelComponent = labelComponentFrom(leaf) else { return }
        let text = labelComponent.value
        let labelModel = LabelModel(text: text, at: leaf.durationInterval.startDuration)
        stratum.add(labelModel)
    }
    
    private func labelComponentFrom(leaf: DurationNode) -> ComponentLabel? {
        for component in leaf.components {
            if let component = component as? ComponentLabel { return component }
        }
        return nil
    }
}