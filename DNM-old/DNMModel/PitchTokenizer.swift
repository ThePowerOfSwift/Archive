//
//  PitchTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class PitchTokenizer: Tokenizer {
    
    internal override func result() throws -> Token {
        do {
            let token = try PitchStringTokenizer(scanner: scanner).makeToken()
            return token
        } catch {
            let token = try FloatTokenizer(scanner: scanner).makeToken()
            return token
        }
    }
}