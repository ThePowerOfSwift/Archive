//
//  EdgeStopCommandTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/28/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class EdgeStopCommandTokenizer: LeafCommandTokenizer {
    
    internal override var identifier: String { return "EdgeStop" }
    
    override func result() throws -> Token {
        return makeTokenContainer()
    }
}