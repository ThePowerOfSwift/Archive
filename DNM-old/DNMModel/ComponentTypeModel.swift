//
//  ComponentTypeModel.swift
//  DNMModel
//
//  Created by James Bean on 12/31/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

public typealias ComponentTypeModel = [PerformerID: [ComponentType: ComponentTypeState]]

public typealias ComponentTypeMultipleStateModel = [
    PerformerID: [ComponentType: [ComponentTypeState]]
]