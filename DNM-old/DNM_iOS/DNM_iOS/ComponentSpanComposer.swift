//
//  ComponentSpanComposer.swift
//  DNM_iOS
//
//  Created by James Bean on 12/18/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation
import DNMModel


public final class ComponentSpanComposer {
    
    private var componentFilter: ComponentFilter
    
    public init(componentFilter: ComponentFilter) {
        self.componentFilter = componentFilter
    }
    
    public func composeWith(componentSelectorTableViewSectionModels: [(ComponentSelectorTableViewHeaderModel, [ComponentSelectorTableViewCellModel])]
    ) -> ComponentFilter
    {
        updateValuesForTableViewSectionModels(componentSelectorTableViewSectionModels)
        return componentFilter
    }
    
    private func createEmptyValueFor(performerID: PerformerID) {
        componentFilter.componentTypeModel[performerID] = [:]
    }
    
    private func updatePerformerValueForHeaderModel(model: ComponentSelectorTableViewHeaderModel,
        withPerformerID performerID: PerformerID
    )
    {
        switch model.state {
        case .On: componentFilter.showComponentType("performer", forPerformerID: performerID)
        case .Off: componentFilter.hideComponentType("performer", forPerformerID: performerID)
        case .MultipleValues: break // no change
        }
    }
    
    private func updateComponentValuesForCellModels(models: [ComponentSelectorTableViewCellModel], withPerformerID performerID: PerformerID
    )
    {
        models.forEach {
            let type = $0.componentType
            switch $0.state {
            case .On:
                componentFilter.showComponentType(type, forPerformerID: performerID)
            case .Off, .Muted:
                componentFilter.hideComponentType(type, forPerformerID: performerID)
            case .MultipleValues:
                break // no change
            }
        }
    }
    
    private func updateValuesForTableViewSectionModels(models:
        [(ComponentSelectorTableViewHeaderModel, [ComponentSelectorTableViewCellModel])]
    )
    {
        models.forEach {
            let performerID = $0.0.performerID
            let headerModel = $0.0
            let cellModels = $0.1
            createEmptyValueFor(performerID)
            updatePerformerValueForHeaderModel(headerModel, withPerformerID: performerID)
            updateComponentValuesForCellModels(cellModels, withPerformerID: performerID)
        }
    }
}