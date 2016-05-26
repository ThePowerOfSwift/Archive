//
//  SlurStopCommandTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/23/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class SlurStopCommandTokenizer: LeafCommandTokenizer {
    
    internal override var identifier: String { return "SlurStop" }
    
    internal override func result() throws -> Token {
        return makeTokenContainer()
    }
}