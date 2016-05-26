//
//  InstrumentDeclarationTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class InstrumentDeclarationTokenizer: CommandTokenizer {
    
    internal override func result() throws -> Token {
        let tokenContainer = makeTokenContainer()
        do {
            let instrumentIDToken = try InstrumentIDTokenizer(scanner: scanner).makeToken()
            do {
                let instrumentTypeToken = try InstrumentTypeTokenizer(scanner: scanner).makeToken()
                tokenContainer.addToken(instrumentIDToken)
                tokenContainer.addToken(instrumentTypeToken)
            }
        }
        return tokenContainer
    }
    
    internal override func makeTokenContainer() -> TokenContainer {
        return TokenContainer(identifier: "InstrumentDeclaration", startIndex: startLocation)
    }
}