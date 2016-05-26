//
//  IntTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class IntTokenizer: Tokenizer {
    
    internal override func result() throws -> Token {
        var intValue: Int32 = 0
        if scanner.scanInt(&intValue) {
            return TokenInt(
                identifier: "Value",
                value: Int(intValue),
                startIndex: startLocation,
                stopIndex: scanner.scanLocation - 1
            )
        }
        throw Error.InvalidIntArgument
    }
}