//
//  ArticulationMarkingCommandTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class ArticulationMarkingCommandTokenizer: LeafCommandTokenizer {
    
    internal override var identifier: String { return "Articulation" }
    
    internal override func addTokenTo(tokenContainer: TokenContainer) {
        do {
            let token = try ArticulationMarkingTokenizer(scanner: scanner).makeToken()
            tokenContainer.addToken(token)
        } catch {
            if !scanner.atEnd { scanner.scanLocation++ }
        }
    }
}