//
//  TreeNode.swift
//  GraphStructures
//
//  Created by James Bean on 8/21/16.
//
//

import ArrayTools

/// Tree Node.
public class TreeNode: Node {
    
    /**
     Error thrown when doing bad things to a `TreeNode` objects.
     */
    public enum Error: ErrorType {
        
        /// Error thrown when trying to insert a TreeNode at an invalid index
        case insertionError
        
        /// Error thrown when trying to remove a TreeNode from an invalid index
        case removalError
        
        /// Error thrown when trying to insert a TreeNode at an invalid index
        case nodeNotFound
    }
    
    // MARK: - Instance Properties
    
    /// Parent `TreeNode`. The root of a tree has no parent.
    public var parent: TreeNode?
    
    /// Children `TreeNode` objects.
    public var children: [TreeNode]
    
    /// - returns: `true` if there are no children. Otherwise, `false`.
    public var isLeaf: Bool { return children.count == 0 }
    
    /// All leaves.
    public var leaves: [TreeNode] {
        
        func descendToGetLeaves(of node: TreeNode, inout result: [TreeNode]) {
            if node.isLeaf { result.append(node) }
            else {
                for child in node.children {
                    descendToGetLeaves(of: child, result: &result)
                }
            }
        }
        
        var result: [TreeNode] = []
        descendToGetLeaves(of: self, result: &result)
        return result
    }
    
    /// - returns: `true` if there is at least one child. Otherwise, `false`.
    public var isContainer: Bool {
        return children.count > 0
    }
    
    /// - returns: `true` if there is no parent. Otherwise, `false`.
    public var isRoot: Bool {
        return parent == nil
    }
    
    /// - returns: `true` if there is no parent. Otherwise, `false`.
    public var root: TreeNode {
        
        func ascendToGetRoot(of node: TreeNode) -> TreeNode {
            guard let parent = node.parent else { return node }
            return ascendToGetRoot(of: parent)
        }
        
        return ascendToGetRoot(of: self)
    }
    
    /// Array of all TreeNode objects between (and including) `self` up to `root`.
    public var pathToRoot: [TreeNode] {
        
        func ascendToGetPathToRoot(of node: TreeNode, result: [TreeNode]) -> [TreeNode] {
            guard let parent = node.parent else { return result + node }
            return ascendToGetPathToRoot(of: parent, result: result + node)
        }
        
        return ascendToGetPathToRoot(of: self, result: [])
    }
    
    /// Height of node.
    public var height: Int {
        
        func descendToGetHeight(of node: TreeNode, result: Int) -> Int {
            if node.isLeaf { return result }
            return node.children
                .map { descendToGetHeight(of: $0, result: result + 1) }
                .reduce(0, combine: max)
        }
        
        return descendToGetHeight(of: self, result: 0)
    }
    
    /// Height of containing tree.
    public var heightOfTree: Int { return root.height }
    
    /// Depth of node.
    public var depth: Int {
        
        func ascendToGetDepth(of node: TreeNode, depth: Int) -> Int {
            guard let parent = node.parent else { return depth }
            return ascendToGetDepth(of: parent, depth: depth + 1)
        }
        
        return ascendToGetDepth(of: self, depth: 0)
    }
    
    // MARK: - Initializers
    
    /**
     Create a `TreeNode`.
     */
    public init(parent: TreeNode? = nil, children: [TreeNode] = []) {
        self.parent = parent
        self.children = children
        super.init()
    }
    
    // MARK: - Instance Methods
    
    /**
     Add the given `node` to `children`.
     */
    public func addChild(node: TreeNode) {
        children.append(node)
        node.parent = self
    }
    
    /**
     Append the given `nodes` to `children`.
     */
    public func addChildren(nodes: [TreeNode]) {
        nodes.forEach(addChild)
    }
    
    /**
     Insert the given `node` at the given `index` of `children`.
     
     - throws: `Error.insertionError` if `index` is out of bounds.
     */
    public func insertChild(node: TreeNode, at index: Int) throws {
        if index > children.count { throw Error.insertionError }
        children.insert(node, atIndex: index)
        node.parent = self
    }
    
    /**
     Remove the given `node` from `children`.
     
     - throws: `Error.removalError` if the given `node` is not held in `children`.
     */
    public func removeChild(node: TreeNode) throws {
        guard let index = children.indexOf({ $0 == node }) else {
            throw Error.nodeNotFound
        }
        try removeChild(at: index)
    }
    
    /**
     Remove the node at the given `index`.
     
     - throws: `Error.removalError` if `index` is out of bounds.
     */
    public func removeChild(at index: Int) throws {
        if index >= children.count { throw Error.nodeNotFound }
        children.removeAtIndex(index)
    }
    
    /**
     - returns: `true` if the given node is contained herein. Otherwise, `false`.
     */
    public func hasChild(child: TreeNode) -> Bool {
        return children.anySatisfy { $0 == child }
    }
    
    /**
     - returns: Child node at the given `index`, if present. Otherwise, `nil`.
     */
    public func child(at index: Int) -> TreeNode? {
        guard children.indices.contains(index) else { return nil }
        return children[index]
    }
    
    /**
     - returns: Returns the leaf node at the given `index`, if present. Otherwise, `nil`.
     */
    public func leaf(at index: Int) -> TreeNode? {
        guard index >= 0 && index < leaves.count else { return nil }
        return leaves[index]
    }
    
    /**
     - returns: `true` if the given node is a leaf. Otherwise, `false`.
     */
    public func hasLeaf(node: TreeNode) -> Bool {
        return leaves.contains(node)
    }
    
    /**
     - returns: `true` if the given node is an ancestor. Otherwise, `false`.
     */
    public func hasAncestor(node: TreeNode) -> Bool {
        return self == node ? false : pathToRoot.anySatisfy { $0 == node }
    }
    
    /**
     - returns: Ancestor at the given distance, if present. Otherwise, `nil`.
     */
    public func ancestor(at distance: Int) -> TreeNode? {
        guard distance < pathToRoot.count else { return nil }
        return pathToRoot[distance]
    }
    
    /**
     - returns: `true` if the given node is a descendent. Otherwise, `false`.
     */
    public func hasDescendent(node: TreeNode) -> Bool {
        if isLeaf { return false }
        if hasChild(node) { return true }
        return children
            .map { $0.hasChild(node) }
            .filter { $0 == true }
            .count > 0
    }
}

// MARK: - Equatable

extension TreeNode: Equatable { }

/**
 - returns: `true` if the parent and children objects of both `TreeNode` objects are 
 equivalent. Otherwise, `false`.
 */
public func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
    return lhs.parent == rhs.parent && lhs.children == rhs.children
}
