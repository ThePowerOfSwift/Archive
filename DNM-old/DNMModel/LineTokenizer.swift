//
//  LineTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class LineTokenizer: CommandTokenizer {
    
    internal override func result() throws -> Token {
        let tokenContainer = makeTokenContainer()
        while !scanner.atEnd {
            if newLine() { break }
            do { try addCommandTokenTo(tokenContainer) }
            catch {
                do { try addLeafTokenTo(tokenContainer) }
                catch { incrementScanner() }
            }
        }
        if tokenContainer.tokens.count > 0 { return tokenContainer }
        throw Error.NoArgumentsFound("I thought you were here to make music...?")
    }

    private func addCommandTokenTo(tokenContainer: TokenContainer) throws {
        guard let command = commandMatch() else { throw Error.InvalidCommand("No Command") }
        let commandTokenizer = CommandTokenizer.tokenizerFor(command, scanner: scanner)
        let commandToken = try commandTokenizer.makeToken()
        tokenContainer.addToken(commandToken)
    }
    
    private func addLeafTokenTo(tokenContainer: TokenContainer) throws {
        let durationToken = try makeTokenForFloatWith("LeafDuration")
        let tokenizer = DurationNodeLeafTokenizer(
            scanner: scanner,
            relativeDurationToken: durationToken
        )
        let token = try tokenizer.makeToken()
        tokenContainer.addToken(token)
    }
    
    private func scanFloat() -> Float? {
        var floatValue: Float = 0.0
        if scanner.scanFloat(&floatValue) { return floatValue }
        return nil
    }
    
    private func addRelativeDurationTokenTo(tokenContainer: TokenContainer) throws {
        let relativeDurationTokenizer = RelativeDurationTokenizer(scanner: scanner)
        let relativeDurationToken = try relativeDurationTokenizer.makeToken()
        tokenContainer.addToken(relativeDurationToken)
    }

    internal override func makeTokenContainer() -> TokenContainer {
        return TokenContainer(identifier: "Line", startIndex: startLocation)
    }
    
    internal override func newLine() -> Bool {
        let isNewLine = super.newLine()
        if isNewLine && !scanner.atEnd { scanner.scanLocation++ }
        return isNewLine
    }
    
    internal override func commandMatch() -> GlobalCommand? {
        let command = super.commandMatch()
        if command != nil && !scanner.atEnd { scanner.scanLocation++ }
        return command
    }
}