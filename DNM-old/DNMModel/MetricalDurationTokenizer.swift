//
//  MetricalDurationTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/22/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class MetricalDurationTokenizer: CommandTokenizer {
    
    private var invalidDurationMessage: String {
        return "Metrical Durations must be in the form of: n,m (beats,subdivisionValue" +
        "- e.g., 3,16)"
    }
    
    internal override func result() throws -> Token {
        let tokenContainer = makeTokenContainer()
        try addTokenForIntWith("Beats", toTokenContainer: tokenContainer)
        guard hasSeperator() else { throw Error.InvalidDurationArgument("No separator") }
        try addTokenForIntWith("Subdivision", toTokenContainer: tokenContainer)
        return tokenContainer
    }
    
    internal override func makeTokenContainer() -> TokenContainer {
        return TokenContainer(identifier: "MetricalDuration", startIndex: startLocation)
    }
    
    private func hasSeperator() -> Bool {
        var str: NSString?
        return scanner.scanString(",", intoString: &str)
    }
}