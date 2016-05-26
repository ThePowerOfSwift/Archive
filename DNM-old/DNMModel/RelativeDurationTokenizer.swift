//
//  RelativeDurationTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/22/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class RelativeDurationTokenizer: Tokenizer {
    
    internal override func result() throws -> Token {
        var token = try makeTokenForIntWith("LeafRelativeDuration")
        if scanString("--") { token.identifier = "InternalRelativeDuration" }
        return token
    }
}