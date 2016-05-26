//
//  DynamicMarkingCharacterViewModel.swift
//  DNM_iOS
//
//  Created by James Bean on 12/28/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import QuartzCore
import DNMModel

public struct DynamicMarkingCharacterViewModel {
    
    public var model: DynamicMarkingCharacterType
    public var height: CGFloat
    
    public init(model: DynamicMarkingCharacterType, height: CGFloat = 10) {
        self.model = model
        self.height = height
    }
}
