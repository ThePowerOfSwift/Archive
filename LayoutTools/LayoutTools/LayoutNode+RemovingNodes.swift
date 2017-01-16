//
//  LayoutNode+RemovingNodes.swift
//  LayoutTools
//
//  Created by James Bean on 7/23/16.
//
//

import TreeTools

extension LayoutNode {
    
    // MARK: - Remove nodes
    
    /**
     Remove a given child `node`.
     
     - throws: `NodeError.removalError` if the given `node` is not contained herein.
     */
    public func removeChild(_ node: LayoutNode) throws {
        guard let index = children.index(of: node) else { throw NodeError.removalError }
        try removeChild(at: index)
    }
    
    /**
     Remove the child node at a given `index`.
     
     - throws: `NodeError.removalError` if no node exists at the given `index`.
     */
    public func removeChild(at index: Int) throws {
        guard children.indices.contains(index) else { throw NodeError.removalError }
        let node = children.remove(at: index)
        removeLayer(for: node)
    }
    
    fileprivate func removeLayer(for node: LayoutNode) {
        node.layer.removeFromSuperlayer()
    }
}
