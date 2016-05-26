//
//  PerformerDeclarationParser.swift
//  DNMModel
//
//  Created by James Bean on 1/17/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public class PerformerDeclarationParser {
    
    private enum Error: ErrorType {
        case Error
    }
    
    private enum InstrumentIDOrInstrumentType {
        case ID, Type
        
        mutating func switchState() {
            switch self {
            case .ID: self = .Type
            case .Type: self = .ID
            }
        }
    }
    
    public func parse(tokenContainer: TokenContainer) throws -> PerformerDeclaration {
        let performerID = try performerIDFrom(tokenContainer)
        return try makePerformerDeclarationWith(tokenContainer, andPerformerID: performerID)
    }
    
    private func performerIDFrom(tokenContainer: TokenContainer) throws -> PerformerID {
        let tokens = tokenContainer.tokens
        guard let tokenString = tokens.first as? TokenString else { throw Error.Error }
        guard tokenString.identifier == "PerformerID" else { throw Error.Error }
        return tokenString.value
    }
    
    private func makePerformerDeclarationWith(tokenContainer: TokenContainer,
        andPerformerID performerID: PerformerID
    ) throws -> PerformerDeclaration
    {
        var declaration = PerformerDeclaration(performerID: performerID)
        for token in tokenContainer.tokens[1..<tokenContainer.tokens.count] {
            guard let instrumentContainer = token as? TokenContainer else { throw Error.Error }

            // wrap
            guard let idToken = instrumentContainer.tokens.first as? TokenString else {
                throw Error.Error
            }
            
            // wrap
            guard let typeToken = instrumentContainer.tokens.second as? TokenInstrumentType
                else {
                throw Error.Error
            }
            
            let instrumentID = idToken.value
            let instrumentType = typeToken.instrumentType
            declaration.updateType(instrumentType, forInstrumentID: instrumentID)
        }
        return declaration
    }
    
    private func instrumentTypeIDPairsFrom(tokenContainer: TokenContainer)
        throws -> [(InstrumentID, InstrumentType)]
    {
        var pairs: [(InstrumentID, InstrumentType)] = []
        var currentInstrumentID: InstrumentID?
        for token in tokenContainer.tokens[1..<tokenContainer.tokens.count] {
            guard let tokenString = token as? TokenString else { continue }
            switch token.identifier {
            case "InstrumentID":
                currentInstrumentID = tokenString.value
            case "InstrumentType":
                guard let instrumentID = currentInstrumentID else { continue }
                guard let type = InstrumentType(rawValue: tokenString.value) else { continue }
                pairs.append((instrumentID, type))
                currentInstrumentID = nil
            default:
                break
            }
        }
        if pairs.count > 0 { return pairs }
        throw Error.Error
    }
}