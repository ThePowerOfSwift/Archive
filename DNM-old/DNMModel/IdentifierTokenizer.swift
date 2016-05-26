//
//  IdentifierTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class IdentifierTokenizer: Tokenizer {
    
    internal var letterSet = NSCharacterSet.letterCharacterSet()
    
    internal override func result() throws -> Token {
        let identifier = try identifierWith(scanner)
        return makeTokenWith(identifier)
    }

    internal func makeTokenWith(identifier: String) -> Token {
        return TokenString(
            identifier: "Identifier",
            value: identifier,
            startIndex: startLocation
        )
    }
    
    internal func identifierWith(scanner: NSScanner) throws -> String {
        var str: NSString?
        if scanner.scanCharactersFromSet(letterSet, intoString: &str) {
            return str as! String
        }
        throw Error.InvalidArgument("Identifiers may only contain alphabetical characters")
    }
}