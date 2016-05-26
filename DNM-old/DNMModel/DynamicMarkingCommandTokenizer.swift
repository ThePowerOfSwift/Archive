//
//  DynamicMarkingCommandTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/22/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class DynamicMarkingCommandTokenizer: LeafCommandTokenizer {
    
    internal override var identifier: String { return "DynamicMarking" }
    
    internal override func addTokenTo(tokenContainer: TokenContainer) throws {
        let dynamicMarkingToken = try DynamicMarkingTokenizer(scanner: scanner).makeToken()
        tokenContainer.addToken(dynamicMarkingToken)
        addSpannerCommandsTo(tokenContainer)
    }
    
    private func addSpannerCommandsTo(tokenContainer: TokenContainer) {
        do { try addSpannerStartTokenTo(tokenContainer) }
        catch {
            do { try addSpannerStopTokenTo(tokenContainer) }
            catch { return }
        }
    }
    
    private func addSpannerStartTokenTo(tokenContainer: TokenContainer) throws {
        let startToken = try SpannerStartCommandTokenizer(scanner: scanner).makeToken()
        tokenContainer.addToken(startToken)
    }
    
    private func addSpannerStopTokenTo(tokenContainer: TokenContainer) throws {
        let stopToken = try SpannerStopCommandTokenizer(scanner: scanner).makeToken()
        tokenContainer.addToken(stopToken)
    }
}