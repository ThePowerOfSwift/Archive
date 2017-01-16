//
//  LinearAxis.swift
//  Plot
//
//  Created by James Bean on 1/11/17.
//
//

/// A default implementation of an `Axis` which returns a one-to-one mapping of a numerical
/// entity to an output position.
public struct LinearAxis <Position>: Axis {

    /// - returns: the value given.
    public let coordinate: (Position) -> Position = { position in position }
    
    /// Create a `LinearAxis`.
    public init() { }
}
