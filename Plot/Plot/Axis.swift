//
//  Axis.swift
//  Plot
//
//  Created by James Bean on 1/11/17.
//
//

/// Interface for types that (abstractly or concretely) defines a coordinate space.
public protocol Axis {

    /// An element which is transformed into a `Position`.
    associatedtype Element
    
    /// Type describing a point in some coordinate system.
    associatedtype Position
    
    /// Calculate a position for the given entity.
    var coordinate: (Element) -> Position { get }
}
