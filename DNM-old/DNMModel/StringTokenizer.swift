//
//  StringTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class StringTokenizer: Tokenizer {
    
    internal override func result() throws -> Token {
        var str: NSString?
        if scanner.scanCharactersFromSet(.alphanumericCharacterSet(), intoString: &str) {
            return TokenString(
                identifier: "String",
                value: str as! String,
                startIndex: startLocation
            )
        } else {
            throw Error.InvalidResult
        }
    }
}