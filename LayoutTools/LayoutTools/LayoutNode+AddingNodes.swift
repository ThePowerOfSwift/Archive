//
//  LayoutNode+AddingNodes.swift
//  LayoutTools
//
//  Created by James Bean on 7/23/16.
//
//

import TreeTools
import QuartzCore

extension LayoutNode {
    
    // MARK: - Add nodes
    
    /**
     Append child node.
     */
    public func addChild(_ node: LayoutNode) {
        children.append(node)
        node.parent = self
        commitLayer(for: node)
    }
    
    /**
     Insert the given `node` at the given `index`.
     
     - throws: `NodeError.insertionError` if the given `index` is out-of-bounds.
     */
    public func insertChild(_ node: LayoutNode, at index: Int) throws {
        guard index >= children.startIndex && index <= children.endIndex else {
            throw NodeError.insertionError
        }
        if index == children.endIndex {
            children.append(node)
        } else {
            children.insert(node, at: index)
        }
        node.parent = self
        commitLayer(for: node)
    }
    
    /**
     Insert the given `node` before another `node`.
     
     - throws: `NodeError.insertionError` if the other `node` is not contained herein.
     */
    public func insertChild(_ node: LayoutNode, before other: LayoutNode) throws {
        guard let index = children.index(of: other) else { throw NodeError.insertionError }
        try insertChild(node, at: index)
    }
    
    /**
     Insert the given `node` after another `node`.
     
     - throws: `NodeError.insertionError` if the other `node` is not contained herein.
     */
    public func insertChild(_ node: LayoutNode, after other: LayoutNode) throws {
        guard let index = children.index(of: other) else { throw NodeError.insertionError }
        try insertChild(node, at: index + 1)
    }
    
    fileprivate func commitLayer(for node: LayoutNode) {
        CATransaction.setDisableActions(true)
        node.layer.removeFromSuperlayer()
        layer.addSublayer(node.layer)
        CATransaction.setDisableActions(false)
    }
}
