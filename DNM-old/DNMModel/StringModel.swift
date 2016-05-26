//
//  StringModel.swift
//  DNMModel
//
//  Created by James Bean on 1/8/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

/**
Model of a String (from a stringed instrument)
*/
public struct StringModel {
    
    private let fundamentalPitch: Pitch

    /**
    Create a StringModel with a fundamental pitch

    - parameter fundamentalPitch: Fundamental pitch of string

    - returns: StringModel
    */
    public init(fundamentalPitch: Pitch) {
        self.fundamentalPitch = fundamentalPitch
    }
    
    /**
     All StringNodes (positions of harmonics) for a given partial of StringModel
     
     - parameter partialNumber: Partial (integer-division of string). Values >= 2.
     
     - returns: StringsNodes for a given partial of StringModel
     */
    public func nodesForPartial(partialNumber: Int) -> [StringNode] {
        guard partialNumber > 1 else { return [] }
        return Array(1..<partialNumber).filter { gcd(partialNumber, $0) == 1 }.map {
            StringNode(
                fundamentalPitch: fundamentalPitch,
                partialNumber: partialNumber,
                partialInstance: $0
            )
        }
    }
}