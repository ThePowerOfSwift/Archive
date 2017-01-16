//
//  GraphTests.swift
//  GraphStructures
//
//  Created by James Bean on 8/21/16.
//
//

import XCTest
@testable import GraphStructures

class GraphTests: XCTestCase {

    func testSingleVertex() {
        let v = Node()
        let graph = Graph()
        graph.addVertex(v)
        XCTAssertEqual(graph.vertices.count, 1)
    }
    
    func testEdgeBetweenTwoVertices() {
        let v1 = Node()
        let v2 = Node()
        let graph = Graph()
        graph.addDirectedEdge(from: v1, to: v2)
        XCTAssertEqual(graph.vertices.count, 2)
        XCTAssertEqual(graph.edges.count, 1)
    }
    
    func testMultipleAttemptsToAddSameNode() {
        let v = Node()
        let graph = Graph()
        graph.addVertex(v)
        graph.addVertex(v)
        graph.addVertex(v)
        XCTAssertEqual(graph.vertices.count, 1)
        XCTAssertEqual(graph.edges.count, 0)
    }
    
    func testBidirectionalRelationshipIsTwoDirectedRelationships() {
        let v1 = Node()
        let v2 = Node()
        let graph = Graph()
        graph.addDirectedEdge(from: v1, to: v2)
        graph.addDirectedEdge(from: v2, to: v1)
        XCTAssertEqual(graph.vertices.count, 2)
        XCTAssertEqual(graph.edges.count, 2)
    }
    
    func testWeightFromSingleEdge() {
        let v1 = Node()
        let v2 = Node()
        let graph = Graph()
        graph.addDirectedEdge(from: v1, to: v2, weight: 1.0)
        let weight = graph.weight(from: v1, to: v2)
        XCTAssertEqual(weight, 1.0)
    }
}
