//
//  InstrumentTypeModel.swift
//  DNMModel
//
//  Created by James Bean on 12/22/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

public typealias InstrumentTypeModel = OrderedDictionary<
    PerformerID, OrderedDictionary<InstrumentID, InstrumentType>
>