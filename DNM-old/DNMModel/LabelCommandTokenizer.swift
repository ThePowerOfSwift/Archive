//
//  LabelCommandTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/29/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class LabelCommandTokenizer: LeafCommandTokenizer {
    
    internal override var identifier: String { return "Label" }
    
    // TODO: implement
    override func result() throws -> Token {
        try scanQuote()
        let text = try getText()
        let tokenContainer = makeTokenContainer()
        let token = TokenString(identifier: "LabelText", value: text, startIndex: startLocation)
        tokenContainer.addToken(token)
        return tokenContainer
    }
    
    // note: currently only supporting single quotation marks
    private func scanQuote() throws {
        var str: NSString?
        if scanner.scanString("'", intoString: &str) { return }
        throw Error.InvalidArgument("Label must have an argument in quotation marks")
    }
    
    private func getText() throws -> String {
        var str: NSString?
        while !scanner.atEnd {
            
            if scanner.scanCharactersFromSet(.newlineCharacterSet(), intoString: &str) {
                throw Error.InvalidArgument(
                    "Label must have text (currently in alphanumeric values)"
                )
            }
            
            if scanner.scanUpToString("'", intoString: &str) {
                let string = str as! String
                try scanQuote()
                return string
            }
        }
        throw Error.InvalidArgument("Label must have text (currently in alphanumeric values)")
    }
}