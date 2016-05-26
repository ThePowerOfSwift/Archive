//
//  FloatTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class FloatTokenizer: Tokenizer {
    
    internal override func result() throws -> Token {
        var floatValue: Float = 0.0
        if scanner.scanFloat(&floatValue) {
            return TokenFloat(
                identifier: "Value",
                value: floatValue,
                startIndex: startLocation,
                stopIndex: scanner.scanLocation - 1
            )
        } else {
            throw Error.InvalidFloatArgument
        }
    }
}