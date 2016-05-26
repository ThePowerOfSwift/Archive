//
//  InstrumentIDTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class InstrumentIDTokenizer: IdentifierTokenizer {
    
    internal override func makeTokenWith(identifier: String) -> Token {
        return TokenString(
            identifier: "InstrumentID",
            value: identifier,
            startIndex: startLocation
        )
    }
    
    internal override func identifierWith(scanner: NSScanner) throws -> String {
        var str: NSString?
        if scanner.scanCharactersFromSet(letterSet, intoString: &str) {
            return str as! String
        }
        throw Error.InvalidInstrumentID(
            "InstrumentIDs may only contain alphabetical characters"
        )
    }
}