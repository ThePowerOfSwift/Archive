//
//  CommandScanner.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class CommandTokenizer: Tokenizer {

    internal let openingValue: String
    
    internal class func tokenizerFor(command: GlobalCommand, scanner: NSScanner)
        -> CommandTokenizer
    {
        var classType: CommandTokenizer.Type {
            switch command {
            case .LineComment:
                return LineCommentCommandTokenizer.self
            case .PerformerDeclaration:
                return PerformerDeclarationCommandTokenizer.self
            case .RehearsalMarking:
                fatalError()
            case .TempoMarking:
                fatalError()
            case .Measure:
                return MeasureCommandTokenizer.self
            case .DurationNodeStackModeMeasure:
                return DurationNodeStackModeMeasureCommandTokenizer.self
            case .DurationNodeStackModeIncrement:
                return DurationNodeStackModeIncrementCommandTokenizer.self
            }
        }
        return classType.init(scanner: scanner, openingValue: command.rawValue)
    }
    
    internal required init(scanner: NSScanner, openingValue: String = "") {
        self.openingValue = openingValue
        super.init(scanner: scanner)
    }
    
    internal override func result() throws -> Token {
        let tokenContainer = makeTokenContainer()
        while !scanner.atEnd {
            if reachedEndOfTask() { break }
            try addTokenTo(tokenContainer)
        }
        if tokenContainer.tokens.count > 0 { return tokenContainer }
        throw Error.NoArgumentsFound("No arguments found")
    }
    
    internal override func makeTokenContainer() -> TokenContainer {
        return TokenContainer(
            identifier: identifier,
            openingValue: openingValue,
            startIndex: startLocation
        )
    }
}