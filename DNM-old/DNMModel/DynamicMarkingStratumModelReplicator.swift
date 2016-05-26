//
//  DynamicMarkingStratumModelReplicator.swift
//  DNMModel
//
//  Created by James Bean on 12/31/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

public struct DynamicMarkingStratumModelReplicator {
    
    private let dynamicMarkingStratumModel: DynamicMarkingStratumModel
    
    public init(dynamicMarkingStratumModel: DynamicMarkingStratumModel) {
        self.dynamicMarkingStratumModel = dynamicMarkingStratumModel
    }
    
    public func replicateIn(durationInterval: DurationInterval) -> DynamicMarkingStratumModel {
        var newModel = dynamicMarkingStratumModel
        let markings = markingModelsIn(durationInterval)
        let spanners = spannerModelsIn(durationInterval)
        newModel.dynamicMarkingModels = markings
        newModel.dynamicMarkingSpannerModels = spanners
        newModel.updateElementModels()
        //newModel.dynamicMarkingElementModels = elementModelsWith(markings, spanners)
        return newModel
    }
    
    private func elementModelsWith(markings: [DynamicMarkingModel],
        _ spanners: [DynamicMarkingSpannerModel]
    ) -> [DynamicMarkingElementModel]
    {
        var result: [DynamicMarkingElementModel] = []
        markings.forEach { result.append($0) }
        spanners.forEach { result.append($0) }
        result = result.sort {
            $0.durationInterval.startDuration < $1.durationInterval.startDuration
        }
        return result
    }
    
    private func markingModelsIn(durationInterval: DurationInterval) -> [DynamicMarkingModel] {
        return dynamicMarkingStratumModel.dynamicMarkingModels.filter {
            durationInterval.intersectsWith($0.durationInterval)
        }
    }
    
    private func spannerModelsIn(durationInterval: DurationInterval)
        -> [DynamicMarkingSpannerModel]
    {
        return dynamicMarkingStratumModel.dynamicMarkingSpannerModels.filter {
            durationInterval.intersectsWith($0.durationInterval)
        }
    }
}