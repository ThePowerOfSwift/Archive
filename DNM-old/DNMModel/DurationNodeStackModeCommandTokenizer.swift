//
//  DurationNodeStackModeCommandTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/24/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class DurationNodeStackModeCommandTokenizer: CommandTokenizer {
    
    internal override func result() throws -> Token {
        let tokenContainer = makeTokenContainer()
        try addDurationNodeRootTokenTo(tokenContainer)
        return tokenContainer
    }
    
    internal func addDurationNodeRootTokenTo(tokenContainer: TokenContainer) throws {
        let token = try DurationNodeRootTokenizer(scanner: scanner).makeToken()
        tokenContainer.addToken(token)
    }
}