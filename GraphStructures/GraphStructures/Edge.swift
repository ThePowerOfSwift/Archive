//
//  Edge.swift
//  GraphStructures
//
//  Created by James Bean on 8/21/16.
//
//

/**
 Edge between two `Node` objects.
 */
public struct Edge {
    
    // MARK: - Instance Properties
    
    /// Source `Node`.
    public let source: Node
    
     /// Source `Destination`.
    public let destination: Node
    
    /// Weight of the `Edge`.
    public let weight: Float?
    
    // MARK: - Initializers
    
    /**
     Create an `Edge`.
     */
    public init(from source: Node, to destination: Node, weight: Float? = nil) {
        self.source = source
        self.destination = destination
        self.weight = weight
    }
}
