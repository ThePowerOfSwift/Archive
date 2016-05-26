//
//  LabelViewModel.swift
//  DNM
//
//  Created by James Bean on 1/29/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import QuartzCore
import DNMModel

public class LabelViewModel {
    
    public let model: LabelModel
    public let x: CGFloat
    public let height: CGFloat
    
    public init(model: LabelModel, x: CGFloat, height: CGFloat) {
        self.model = model
        self.x = x
        self.height = height
    }
}