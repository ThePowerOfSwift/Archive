//
//  ComponentSelectorTableViewHeaderModel.swift
//  DNM_iOS
//
//  Created by James Bean on 12/16/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation
import DNMModel

public class ComponentSelectorTableViewHeaderModel {
    
    public var hasMultipleValues: Bool = false
    
    public var performerID: PerformerID
    public var text: String
    public var belongsToCurrentViewer: Bool
    public var state: ComponentSelectorTableViewHeaderState
    
    public init(
        performerID: PerformerID,
        states: [ComponentTypeState],
        belongsToCurrentViewer: Bool
    )
    {
        self.performerID = performerID
        self.text = performerID
        self.belongsToCurrentViewer = belongsToCurrentViewer
        
        let uniqueStates: [ComponentTypeState] = states.unique()
        switch uniqueStates.count {
        case 0:
            // guard against this condition
            break
        case 1:
            hasMultipleValues = false
            switch uniqueStates[0] {
            case .Show: state = .On
            case .Hide: state = .Off
            }
        default:
            hasMultipleValues = true
            state = .MultipleValues
        }
        
        // manage default state
        if performerID == "omni" { self.state = .On }
        else {
            switch belongsToCurrentViewer {
            case true: self.state = .On
            case false: self.state = .Off
            }
        }
    }
    
    private func nextState() -> ComponentSelectorTableViewHeaderState {
        func composeStates() -> [ComponentSelectorTableViewHeaderState] {
            switch hasMultipleValues {
            case true: return [.On, .Off, .MultipleValues]
            case false: return [.On, .Off]
            }
        }
        
        let states = composeStates()
        
        if let index = states.indexOf(state) {
            let newIndex = (index + 1) % states.count
            return states[newIndex]
        } else {
            return states[0]
        }
    }
    
    public func hit() {
        self.state = nextState()
    }
}