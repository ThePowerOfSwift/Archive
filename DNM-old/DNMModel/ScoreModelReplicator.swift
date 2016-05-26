//
//  ScoreModelReplicator.swift
//  DNMModel
//
//  Created by James Bean on 12/31/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

public struct ScoreModelReplicator {
    
    private let scoreModel: ScoreModel
    
    public init(scoreModel: ScoreModel) {
        self.scoreModel = scoreModel
    }
    
    public func replicateIn(durationInterval: DurationInterval) -> ScoreModel? {
        guard scoreModel.durationInterval.intersectsWith(durationInterval) else { return nil }
        var newModel = scoreModel
        newModel.measures = measuresModelsIn(durationInterval)
        newModel.durationNodes = durationNodesIn(durationInterval)
        newModel.dynamicMarkingStratumModels = dynamicMarkingStratumModelsIn(durationInterval)
        newModel.instrumentTypeModel = scoreModel.instrumentTypeModel
        return newModel
    }
    
    private func dynamicMarkingStratumModelsIn(durationInterval: DurationInterval)
        -> [DynamicMarkingStratumModel]
    {
        return scoreModel.dynamicMarkingStratumModels.map {
            $0.dynamicMarkingStratumModelIn(durationInterval)
        }
    }

    private func measuresModelsIn(durationInterval: DurationInterval) -> [MeasureModel] {
        return scoreModel.measures.filter { durationInterval.contains($0.durationInterval) }
    }
    
    private func durationNodesIn(durationInterval: DurationInterval) -> [DurationNode] {
        return scoreModel.durationNodes.filter {
            durationInterval.contains($0.durationInterval)
        }

    }
}
