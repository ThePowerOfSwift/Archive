//
//  DurationNodeLeafTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/24/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class DurationNodeLeafTokenizer: Tokenizer {
    
    internal override var identifier: String { return "Leaf" }
    
    private let relativeDurationToken: Token
    
    internal init(scanner: NSScanner, relativeDurationToken: Token) {
        self.relativeDurationToken = relativeDurationToken
        super.init(scanner: scanner)
    }
    
    internal override func result() throws -> Token {
        let tokenContainer = makeTokenContainer()
        tokenContainer.addToken(relativeDurationToken)
        while !scanner.atEnd {
            if reachedEndOfTask() { break }
            do { try addLeafCommandTokenTo(tokenContainer) }
            catch { incrementScanner() }
        }
        return tokenContainer
    }
    
    private func addLeafCommandTokenTo(tokenContainer: TokenContainer) throws {
        guard let command = leafCommandMatch() else { throw Error.InvalidCommand("No Command") }
        let commandTokenizer = LeafCommandTokenizer.tokenizerFor(command, scanner:scanner)
        let commandToken = try commandTokenizer.makeToken()
        tokenContainer.addToken(commandToken)
    }
    
    private func leafCommandMatch() -> LeafCommand? {
        for command in iterateEnum(LeafCommand) {
            if scanString(command.rawValue) { return command }
        }
        return nil
    }   
}