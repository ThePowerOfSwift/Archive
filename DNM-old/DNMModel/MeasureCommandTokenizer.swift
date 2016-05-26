//
//  MeasureTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/22/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class MeasureCommandTokenizer: CommandTokenizer {

    internal override var identifier: String { return "Measure" }
    
    internal override func result() throws -> Token {
        let tokenContainer = makeTokenContainer()
        do { try addDurationTokenTo(tokenContainer) }
        catch {
            // When no Duration is declared for a Measure, the Duration is inferred by the
            // - musical information declared within it
        }
        return tokenContainer
    }
    
    private func addDurationTokenTo(tokenContainer: TokenContainer) throws {
        let durationToken = try MetricalDurationTokenizer(scanner: scanner).makeToken()
        tokenContainer.addToken(durationToken)
    }
}