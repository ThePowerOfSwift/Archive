//
//  LineCommentCommandTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/26/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class LineCommentCommandTokenizer: CommandTokenizer {
    
    internal override var identifier: String { return "LineComment" }
    
    internal override func result() throws -> Token {
        let tokenContainer = makeTokenContainer()
        while !scanner.atEnd {
            if newLine() { break }
            incrementScanner()
        }
        return tokenContainer
    }
}