//
//  RestCommandTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/24/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class RestCommandTokenizer: CommandTokenizer {
    
    internal override var identifier: String { return "Rest" }
    
    internal override func result() throws -> Token {
        return makeTokenContainer()
    }
}