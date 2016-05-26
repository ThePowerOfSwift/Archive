//
//  PerformerDeclarationCommandTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class PerformerDeclarationCommandTokenizer: CommandTokenizer {
    
    internal override var identifier: String { return "PerformerDeclaration" }
    
    private let letterSet = NSCharacterSet.letterCharacterSet()
    private var letterAndUnderscoreSet: NSCharacterSet {
        let set = NSMutableCharacterSet.letterCharacterSet()
        set.formUnionWithCharacterSet(NSCharacterSet(charactersInString: "_"))
        return set
    }
    
    internal override func result() throws -> Token {
        let tokenContainer = makeTokenContainer()
        let performerIDToken = try PerformerIDTokenizer(scanner: scanner).makeToken()
        tokenContainer.addToken(performerIDToken)
        while !scanner.atEnd {
            if reachedEndOfTask() { break }
            try addTokenTo(tokenContainer)
            incrementScanner()
        }
        return tokenContainer
    }
    
    internal override func addTokenTo(tokenContainer: TokenContainer) throws {
        let token = try InstrumentDeclarationTokenizer(scanner: scanner).makeToken()
        tokenContainer.addToken(token)
    }
}