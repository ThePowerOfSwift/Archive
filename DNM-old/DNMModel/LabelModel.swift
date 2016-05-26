//
//  LabelModel.swift
//  DNMModel
//
//  Created by James Bean on 1/20/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public struct LabelModel: DurationSpanning {
    
    public let text: String
    public let offsetDuration: Duration
    
    public var durationInterval: DurationInterval {
        return DurationInterval(startDuration: offsetDuration)
    }
    
    public init(text: String, at duration: Duration) {
        self.text = text
        self.offsetDuration = duration
    }
}