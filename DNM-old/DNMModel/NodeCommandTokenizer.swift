//
//  NodeCommandTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/24/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class NodeCommandTokenizer: LeafCommandTokenizer {
    
    internal override var identifier: String { return "Node" }
    
    override func result() throws -> Token {
        return makeTokenContainer()
    }
}