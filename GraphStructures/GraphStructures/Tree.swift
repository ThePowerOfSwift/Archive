//
//  Tree.swift
//  GraphStructures
//
//  Created by James Bean on 8/21/16.
//
//

import Foundation

// MARK: - Tree
public class Tree {
    
    // MARK: - Instance Properties
    
    /// Root `TreeNode` of the `Tree`.
    public var root: TreeNode
    
    // MARK: - Initializers
    
    /**
     Create a `Tree`.
     */
    public init(root: TreeNode) {
        self.root = root
    }
}