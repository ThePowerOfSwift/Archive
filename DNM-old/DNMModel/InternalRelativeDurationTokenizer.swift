//
//  InternalRelativeDurationTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/22/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class InternalRelativeDurationTokenizer: Tokenizer {
    
    internal override func result() throws -> Token {
        
        let intToken = try IntTokenizer(scanner: scanner).makeToken()
        if hasSymbol() { return intToken }
        throw Error.InvalidDurationArgument("Most likely a leaf relative Duration")
    }
    
    private func hasSymbol() -> Bool {
        var str: NSString?
        return scanner.scanString("--", intoString: &str)
    }
}