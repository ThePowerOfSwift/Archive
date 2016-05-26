//
//  InstrumentTypeTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class InstrumentTypeTokenizer: Tokenizer {
    
    private var letterAndUnderscoreSet: NSCharacterSet {
        let set = NSMutableCharacterSet.letterCharacterSet()
        set.formUnionWithCharacterSet(NSCharacterSet(charactersInString: "_"))
        return set
    }
    
    internal override func result() throws -> Token {
        let instrumentType = try instrumentTypeWith(scanner)
        return TokenInstrumentType(
            identifier: "InstrumentType",
            instrumentType: instrumentType,
            startIndex: startLocation,
            stopIndex: scanner.scanLocation - 1
        )
    }
    
    private func instrumentTypeWith(scanner: NSScanner) throws -> InstrumentType {
        var str: NSString?
        if scanner.scanCharactersFromSet(letterAndUnderscoreSet, intoString: &str) {
            if let type = InstrumentType(rawValue: str as! String) { return type }
            throw Error.InvalidInstrumentType("Unsupported InstrumentType: \(str as! String)")
        }
        throw Error.InvalidInstrumentType(
            "InstrumentType arguments can only contain alphabetical and underscore characters"
        )
    }
}