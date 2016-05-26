//
//  SpannerStopCommandTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/22/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class SpannerStopCommandTokenizer: CommandTokenizer {
    
    internal override func result() throws -> Token {
        var str: NSString?
        if scanner.scanString("]", intoString: &str) {
            return makeTokenContainer()
        }
        throw Tokenizer.Error.InvalidResult
    }
    
    internal override func makeTokenContainer() -> TokenContainer {
        return TokenContainer(
            identifier: "SpannerStop", openingValue: "]", startIndex: startLocation
        )
    }
}