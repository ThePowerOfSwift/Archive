//
//  InstrumentEventRest.swift
//  DNM
//
//  Created by James Bean on 1/11/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public class InstrumentEventRest: InstrumentEvent {
    
    internal override func getDescription() -> String {
        return "\(instrument); x: \(x); stemDirection: \(stemDirection): REST"
    }
}