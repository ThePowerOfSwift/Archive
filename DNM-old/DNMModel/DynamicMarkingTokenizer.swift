//
//  DynamicMarkingTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class DynamicMarkingTokenizer: Tokenizer {
    
    let dynamicMarkingSet = NSCharacterSet(charactersInString: "opmf")
    
    internal override func result() throws -> Token {
        var str: NSString?
        if scanner.scanCharactersFromSet(dynamicMarkingSet, intoString: &str) {
            return TokenString(
                identifier: "DynamicMarking",
                value: str as! String,
                startIndex: startLocation
            )
        } else {
            throw Error.InvalidDynamicMarkingArgument(
                "DynamicMarkings can only contain characters from the set { ompf }"
            )
        }
    }
}