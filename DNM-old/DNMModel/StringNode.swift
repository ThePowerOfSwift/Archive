//
//  StringNode.swift
//  DNMModel
//
//  Created by James Bean on 1/8/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

/**
Model of a harmonic node (a single, integer-division, position along string)
*/
public struct StringNode: Equatable {
    
    /// Sounding pitch of Node
    public var soundingPitch: Pitch { return getSoundingPitch() }
    
    /// Fingered pitch
    public var fingeredPitch: Pitch { return getFingeredPitch() }
    
    /// Position of Node along string
    public var position: Float { return getPosition() }

    private let fundamentalPitch: Pitch
    private let partialNumber: Int
    private let partialInstance: Int
    
    /**
    Create a StringNode

    - parameter fundamentalPitch: Fundamental pitch of String containing this Node
    - parameter partialNumber:    Divisor of String length (>= 2)
    - parameter partialInstance:  Divisor of partialNumber (1...partialNumber-1)

    - returns: StringNode
    */
    public init(fundamentalPitch: Pitch, partialNumber: Int, partialInstance: Int) {
        self.fundamentalPitch = fundamentalPitch
        self.partialNumber = partialNumber
        self.partialInstance = partialInstance
    }
    
    private func getSoundingPitch() -> Pitch {
        return fundamentalPitch.pitchForPartial(partialNumber)
    }
    
    private func getFingeredPitch() -> Pitch {
        let stringLength = 1 - position
        let newFreq = Frequency(fundamentalPitch.frequency.value / stringLength)
        let newPitch = Pitch(frequency: newFreq)
        return newPitch
    }
    
    private func getPosition() -> Float {
        return Float(partialInstance) / Float(partialNumber)
    }
}

// MARK: - CustomStringConvertible
extension StringNode: CustomStringConvertible {
    
    /// String representation of StringNode
    public var description: String {
        return "(\(partialInstance)/\(partialNumber)): \(soundingPitch)"
    }
}

/**
Check equality of two StringNodes

- parameter lhs: First StringNode
- parameter rhs: Second StringNode

- returns: If StringNodes are equal
*/
public func == (lhs: StringNode, rhs: StringNode) -> Bool {
    return (
        lhs.fundamentalPitch == rhs.fundamentalPitch &&
        lhs.partialNumber == rhs.partialNumber &&
        lhs.partialInstance == rhs.partialInstance
    )
}