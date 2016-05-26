//
//  ComponentSelectorTableViewCellModel.swift
//  DNM_iOS
//
//  Created by James Bean on 12/16/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation
import DNMModel

public class ComponentSelectorTableViewCellModel: CustomStringConvertible {
    
    public var description: String {
        return "\(text): \(state); isMuted: \(isMuted); hasMultipleValues: \(hasMultipleValues)"
    }
    
    public var hasMultipleValues: Bool = false
    public var isMuted: Bool = false

    public var componentType: ComponentType
    public var text: String
    public var state: ComponentSelectorTableViewCellState = .Off
    
    public var previousState: ComponentSelectorTableViewCellState?
    
    // style differently if belongs to currentViewer than if it belongs to someone else
    public var belongsToCurrentViewer: Bool = false
    
    public init(
        componentType: ComponentType,
        states: [ComponentTypeState],
        belongsToCurrentViewer: Bool
    )
    {
        self.componentType = componentType
        self.text = componentType
        self.belongsToCurrentViewer = belongsToCurrentViewer
        
        let uniqueStates: [ComponentTypeState] = states.unique()
        
        // maange cell state, with componentTypeState (Show / Hide)
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
    }
    
    public func hit() {
        self.state = nextState()
    }
    
    public func goToNextState() {
        self.state = nextState()
    }
    
    public func mute() {
        self.isMuted = true
        switch state {
        case .On, .MultipleValues:
            previousState = state
            state = .Muted
        default:
            previousState = state
        }
    }
    
    public func unmute() {
        self.isMuted = false
        if let previousState = previousState {
            self.state = previousState
        } else  {
            self.state = .On
        }
    }
    
    private func nextState() -> ComponentSelectorTableViewCellState {
        
        func composeStates() -> [ComponentSelectorTableViewCellState] {
            switch (isMuted, hasMultipleValues) {
            case (false, false): return [.On, .Off]
            case (true, false): return [.On, .Off]
            case (false, true): return [.MultipleValues, .On, .Off]
            case (true, true): return [.MultipleValues, .Muted, .Off]
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
}