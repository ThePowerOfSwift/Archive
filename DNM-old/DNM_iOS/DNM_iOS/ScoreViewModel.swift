//
//  ScoreViewModel.swift
//  DNM_iOS
//
//  Created by James Bean on 12/12/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation
import DNMModel

public struct ScoreViewModel {
    
    /// The model of a piece of music
    public let scoreModel: ScoreModel

    /// Data structure containing the current Viewer and all other Viewers of ScoreView
    public var viewerProfile: ViewerProfile
    
    /// Collection of which musical information to render in a given DurationInterval
    public var componentFilters = ComponentFilters()
    
    /**
    Create a ScoreViewModel with a ScoreModel

    - parameter scoreModel: The model of a piece of Music

    - returns: ScoreViewModel
    */
    public init(scoreModel: ScoreModel, viewerProfile: ViewerProfile) {
        self.scoreModel = scoreModel
        self.viewerProfile = viewerProfile
        setDefaultComponentSpan()
    }
    
    public mutating func setDefaultComponentSpan() {
        
        // create component span with duration of entire piece
        var componentFilter = ComponentFilter(durationInterval: scoreModel.durationInterval)
        
        // make sure that there is a value at with the key: performerID
        func ensureStateByComponentTypeByPerformerID(performerID: PerformerID) {
            if componentFilter.componentTypeModel[performerID] == nil {
                componentFilter.componentTypeModel[performerID] = [:]
            }
        }

        // switch if this is the full score, or if this is an individual viewer
        switch viewerProfile.viewer.type {
        case .Omni:
            
            // show all
            for (performerID, componentTypes) in scoreModel.componentTypesByPerformerID {
                ensureStateByComponentTypeByPerformerID(performerID)
                componentTypes.forEach {
                    componentFilter.componentTypeModel[performerID]![$0] = .Show
                }
            }
        case .Performer:
            
            // show if component type belongs to viewer, otherwise hide
            for (performerID, componentTypes) in scoreModel.componentTypesByPerformerID {
                ensureStateByComponentTypeByPerformerID(performerID)
                componentTypes.forEach {
                    switch viewerProfile.viewer.identifier {
                    case performerID:
                        // show
                        componentFilter.componentTypeModel[performerID]![$0] = .Show
                    default:
                        // hide
                        componentFilter.componentTypeModel[performerID]![$0] = .Hide
                    }
                }
            }
        }

        // set default ComponentFilter for whole piece
        componentFilters = ComponentFilters(componentFilter: componentFilter)
    }
    
    /**
    Add a ComponentFilter

    - parameter componentFilter: Collection of which musical information to render in a given DurationInterval
    */
    public mutating func addComponentFilter(componentFilter: ComponentFilter) {
        componentFilters.addComponentFilter(componentFilter)
    }
}

extension ScoreViewModel: CustomStringConvertible {
    
    public var description: String {
        var result = "\(viewerProfile)"
        result += ":\n\(scoreModel)"
        return result
    }
}