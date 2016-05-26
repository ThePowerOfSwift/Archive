//
//  LabelStratumModel.swift
//  DNMModel
//
//  Created by James Bean on 1/29/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public struct LabelStratumModel {
    
    public let identifier: PerformerID
    public var labelModels: [LabelModel] = []
    
    public init(identifier: PerformerID) {
        self.identifier = identifier
    }
    
    public mutating func add(labelModel: LabelModel) {
        self.labelModels.append(labelModel)
    }
}