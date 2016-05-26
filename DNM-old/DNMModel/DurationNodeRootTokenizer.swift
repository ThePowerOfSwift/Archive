//
//  DurationNodeRootTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/24/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class DurationNodeRootTokenizer: CommandTokenizer {

    private var errorMessage: String { return getErrorMessage() }
    
    internal override var identifier: String { return "DurationNodeRoot" }
    
    internal override func result() throws -> Token {
        let tokenContainer = makeTokenContainer()
        do { try addDurationTokenTo(tokenContainer) }
        catch {
            do { try addIntervalModeInferringTokenTo(tokenContainer) }
            catch { throw Error.InvalidDurationNodeRootArgument(errorMessage) }
        }
        try addPerformerIDTokenTo(tokenContainer)
        try addInstrumentIDTokenTo(tokenContainer)
        if tokenContainer.tokens.count > 0 { return tokenContainer }
        throw Error.NoArgumentsFound(errorMessage)
    }

    private func addDurationTokenTo(tokenContainer: TokenContainer) throws {
        let durationToken = try MetricalDurationTokenizer(scanner: scanner).makeToken()
        tokenContainer.addToken(durationToken)
    }
    
    private func addIntervalModeInferringTokenTo(tokenContainer: TokenContainer) throws {
        try addTokenFor("@",
            withIdentifier: "DurationNodeIntervalModeInferring",
            toTokenContainer: tokenContainer
        )
    }
    
    private func addPerformerIDTokenTo(tokenContainer: TokenContainer) throws {
        let performerIDToken = try PerformerIDTokenizer(scanner: scanner).makeToken()
        tokenContainer.addToken(performerIDToken)
    }
    
    private func addInstrumentIDTokenTo(tokenContainer: TokenContainer) throws {
        let instrumentIDToken = try InstrumentIDTokenizer(scanner: scanner).makeToken()
        tokenContainer.addToken(instrumentIDToken)
    }
    
    // consider moving this method up in the hierarchy
    private func getErrorMessage() -> String {
        return "DurationNodeRoot must have either a Duration " +
        "(in the form of n,m (beats, subdivisionValue)) for IntervalEnforcingMode" +
        "or '@' for IntervalInferringMode, followed by " +
        "a PerformerID and InstrumentID pair"
    }
}