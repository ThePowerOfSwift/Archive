//
//  ExtensionStopCommandTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/23/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class ExtensionStopCommandTokenizer: LeafCommandTokenizer {
    
    internal override var identifier: String { return "ExtensionStop" }
    
    internal override func result() throws -> Token {
        return makeTokenContainer()
    }
}