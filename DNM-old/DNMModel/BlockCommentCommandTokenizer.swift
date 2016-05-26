//
//  BlockCommentCommandTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/26/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class BlockCommentCommandTokenizer: CommandTokenizer {
    
    internal override var identifier: String { return "BlockComment" }
    
    internal override func result() throws -> Token {
        let tokenContainer = makeTokenContainer()
        while !scanner.atEnd {
            if matchBlockCommentStop() { break }
            incrementScanner()
        }
        return tokenContainer
    }
    
    private func matchBlockCommentStop() -> Bool {
        var str: NSString?
        return scanner.scanString("*/", intoString: &str)
    }
}