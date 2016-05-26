//
//  DynamicMarkingViewModel.swift
//  DNM_iOS
//
//  Created by James Bean on 12/28/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import QuartzCore
import DNMModel

public struct DynamicMarkingViewModel: DynamicMarkingElementViewModel {
    
    public let model: DynamicMarkingModel
    public let x: CGFloat
    public let height: CGFloat
    
    public var dynamicMarkingCharacterViewModels: [DynamicMarkingCharacterViewModel] = []
    
    public init(model: DynamicMarkingModel, x: CGFloat, height: CGFloat) {
        self.model = model
        self.x = x
        self.height = height
        populateDynamicMarkingCharacterViewModels()
    }
    
    private mutating func populateDynamicMarkingCharacterViewModels() {
        dynamicMarkingCharacterViewModels = model.characterTypes.map {
            DynamicMarkingCharacterViewModel(model: $0, height: height)
        }
    }
}