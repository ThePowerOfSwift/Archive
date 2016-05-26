//
//  DynamicMarkingModel.swift
//  DNMModel
//
//  Created by James Bean on 12/28/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

/**
Model of a DynamicMarking
*/
public struct DynamicMarkingModel: DynamicMarkingElementModel, Equatable {
    
    /// String value of a DynamicMarking (e.g., "fff", "ppp", "mf", "mp", "offffp", etc.)
    public let stringValue: String
    
    /// DurationInterval of a DynamicMarking
    public let durationInterval: DurationInterval

    public var characterTypes: [DynamicMarkingCharacterType] { return getCharacterTypes() }
    
    /// Numerical Representation of a DynamicMarking at beginning
    public var initialNumericalValue: DynamicMarkingNumericalRepresentation? {
        return getInitialNumericalValue()
    }
    
    /// Numerical Representation of a Dynami
    public var finalNumericalValue: DynamicMarkingNumericalRepresentation? {
        return getFinalNumericalValue()
    }

    private var numericalValues: [DynamicMarkingNumericalRepresentation]? {
        return getNumericalValues()
    }
    
    /**
    Create a DynamicMarkingModel

    - parameter stringValue:      String value of a DynamicMarking
    - parameter durationInterval: DurationInterval of a DynamicMarking

    - returns: DynamicMarkingModel
    */
    public init(stringValue: String, durationInterval: DurationInterval = DurationIntervalZero)
    {
        self.stringValue = stringValue
        self.durationInterval = durationInterval
    }
    
    private func getNumericalValues() -> [DynamicMarkingNumericalRepresentation]? {
        let representer = DynamicMarkingNumericalRepresenter(string: stringValue)
        return try? representer.getNumericalRepresentation()
    }
    
    private func getInitialNumericalValue() -> DynamicMarkingNumericalRepresentation? {
        return numericalValues?.first
    }
    
    private func getFinalNumericalValue() -> DynamicMarkingNumericalRepresentation? {
        return numericalValues?.last
    }
    
    private func getCharacterTypes() -> [DynamicMarkingCharacterType] {
        return stringValue.characters.map { characterTypeWith(String($0)) }
            .filter { $0 != nil }
            .map { $0! }
    }
    
    private func characterTypeWith(string: String) -> DynamicMarkingCharacterType? {
        return DynamicMarkingCharacterType(rawValue: string)
    }
}

extension DynamicMarkingModel: CustomStringConvertible {
    
    public var description: String { return stringValue }
}

/**
Equality of two DynamicMarkingModels

- parameter lhs: DynamicMarkingModel
- parameter rhs: DynamicMarkingModel

- returns: True if equal. Otherwise false.
*/
public func == (lhs: DynamicMarkingModel, rhs: DynamicMarkingModel) -> Bool {
    return lhs.stringValue == rhs.stringValue && lhs.durationInterval == rhs.durationInterval
}
