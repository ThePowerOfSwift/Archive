//
//  AdjacencyList.swift
//  GraphStructures
//
//  Created by James Bean on 8/21/16.
//
//

internal class AdjacencyList {
    
    var edgeLists: [EdgeList] = []
    
    init() { }
    
    subscript (vertex: Node) -> EdgeList? {
        for edgeList in edgeLists {
            if edgeList.vertex === vertex {
                return edgeList
            }
        }
        return nil
    }
    
    func addDirectedEdge(from source: Node, to destination: Node, weight: Float? = nil) {
        addVertex(source)
        addVertex(destination)
        
        let sourceEdgeList = self[source]!
        sourceEdgeList.addEdge(to: destination, weight: weight)
        
        addEdgeList(sourceEdgeList)
    }
    
    func addVertex(vertex: Node) {
        if self[vertex] == nil {
            let edgeList = EdgeList(vertex: vertex)
            addEdgeList(edgeList)
        }
    }
    
    func addEdgeList(edgeList: EdgeList) {
        if self[edgeList.vertex] == nil {
            edgeLists.append(edgeList)
        }
    }
}

extension AdjacencyList: SequenceType {
    
    func generate() -> AnyGenerator<EdgeList> {
        var generator = edgeLists.generate()
        return AnyGenerator { generator.next() }
    }
}
