//
//  PitchCommandTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class PitchCommandTokenizer: LeafCommandTokenizer {
    
    internal override var identifier: String { return "Pitch" }
    
    internal override func addTokenTo(tokenContainer: TokenContainer) throws {
        do {
            let token = try PitchTokenizer(scanner: scanner).makeToken()
            tokenContainer.addToken(token)
        } catch {
            if !scanner.atEnd { scanner.scanLocation++ }
        }
    }
}