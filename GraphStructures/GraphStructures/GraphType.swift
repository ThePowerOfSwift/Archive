//
//  GraphType.swift
//  GraphStructures
//
//  Created by James Bean on 8/21/16.
//
//

/// Abstract graph.
public protocol GraphType {
    
    // MARK: - Instance Properties
    
    /// All vertices contained herein.
    var vertices: [Node] { get }
    
    /// All edges contained herein.
    var edges: [Edge] { get }
    
    var weight: Float? { get }
    
    // MARK: - Instance Methods
    
    /**
     Add the given `vertex`.
     */
    mutating func addVertex(vertex: Node)
    
    /**
     Add a directed edge from one vertex to another, with an optional weight.
     */
    mutating func addDirectedEdge(from source: Node, to destination: Node, weight: Float?)
    
    /**
     - returns: The weight between two nodes, if such an edge exists, and it has a weight.
     Otherwise, `nil`.
     */
    func weight(from source: Node, to destination: Node) -> Float?
    
    /**
     - returns: All `Edge` values emanating from the given `source` vertex.
     */
    func edges(from source: Node) -> [Edge]
}
