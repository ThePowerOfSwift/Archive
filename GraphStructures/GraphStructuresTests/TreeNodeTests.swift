//
//  TreeNodeTests.swift
//  GraphStructures
//
//  Created by James Bean on 8/21/16.
//
//

import XCTest
@testable import GraphStructures

class TreeNodeTests: XCTestCase {

    func testAddChild() {
        let parent = TreeNode()
        let child = TreeNode()
        parent.addChild(child)
        XCTAssertEqual(parent.children.count, 1)
        XCTAssert(child.parent! === parent)
    }
    
    func testAddChildrenVariadic() {
        let parent = TreeNode()
        parent.addChildren([TreeNode(), TreeNode(), TreeNode()])
        XCTAssertEqual(parent.children.count, 3)
    }
    
    func testAddChildrenArray() {
        let parent = TreeNode()
        parent.addChildren([TreeNode(), TreeNode(), TreeNode()])
        XCTAssertEqual(parent.children.count, 3)
    }
    
    func testInsertChildAtIndexThrows() {
        let parent = TreeNode()
        let child = TreeNode()
        do {
            try parent.insertChild(child, at: 1)
            XCTFail()
        } catch { }
    }
    
    func testInsertChildAtIndexValidEmpty() {
        let parent = TreeNode()
        do { try parent.insertChild(TreeNode(), at: 0) }
        catch { XCTFail() }
    }
    
    func testInsertChildAtIndexValidNotEmpty() {
        let parent = TreeNode()
        parent.addChild(TreeNode())
        do { try parent.insertChild(TreeNode(), at: 0) }
        catch { XCTFail() }
    }
    
    func testRemoveChildAtIndexThrows() {
        let parent = TreeNode()
        do {
            try parent.removeChild(at: 0)
            XCTFail()
        } catch { }
    }
    
    func testRemoveChildAtIndexValid() {
        let parent = TreeNode()
        parent.addChild(TreeNode())
        do { try parent.removeChild(at: 0) }
        catch { XCTFail() }
        
    }
    
    func testRemoveChildThrows() {
        let parent = TreeNode()
        let child = TreeNode()
        do {
            try parent.removeChild(child)
            XCTFail()
        } catch { }
    }
    
    func testRemoveChildValid() {
        let parent = TreeNode()
        let child = TreeNode()
        parent.addChild(child)
        do { try parent.removeChild(child) }
        catch { XCTFail() }
    }
    
    func testHasChildFalseEmpty() {
        let parent = TreeNode()
        XCTAssertFalse(parent.hasChild(TreeNode()))
    }
    
    func testHasChildFalse() {
        let parent = TreeNode()
        parent.addChild(TreeNode())
        XCTAssertFalse(parent.hasChild(TreeNode()))
    }
    
    func testHasChildTrue() {
        let parent = TreeNode()
        let child = TreeNode()
        parent.addChild(child)
        XCTAssert(parent.hasChild(child))
    }
    
    func testChildAtIndexNilEmpty() {
        let parent = TreeNode()
        XCTAssertNil(parent.child(at: 0))
    }
    
    func testChildAtIndexNil() {
        let parent = TreeNode()
        parent.addChild(TreeNode())
        XCTAssertNil(parent.child(at: 1))
    }
    
    func testChildAtIndexValidSingle() {
        let parent = TreeNode()
        let child = TreeNode()
        parent.addChild(child)
        XCTAssert(parent.child(at: 0) === child)
    }
    
    func testChildAtIndexValidMultiple() {
        let parent = TreeNode()
        let child1 = TreeNode()
        let child2 = TreeNode()
        parent.addChild(child1)
        parent.addChild(child2)
        XCTAssert(parent.child(at: 1) === child2)
    }
    
    func testLeafAtIndexSelf() {
        let leaf = TreeNode()
        XCTAssert(leaf.leaf(at: 0) === leaf)
    }
    
    func testLeafAtIndexNilLeaf() {
        let leaf = TreeNode()
        XCTAssertNil(leaf.leaf(at: 1))
    }
    
    func testLeafAtIndexNilSingleDepth() {
        let parent = TreeNode()
        for _ in 0..<5 { parent.addChild(TreeNode()) }
        XCTAssertNil(parent.leaf(at: 5))
    }
    
    func testLeafAtIndexNilMultipleDepth() {
        let root = TreeNode()
        let internal1 = TreeNode()
        for _ in 0..<2 { internal1.addChild(TreeNode()) }
        let internal2 = TreeNode()
        for _ in 0..<2 { internal2.addChild(TreeNode()) }
        root.addChild(internal1)
        root.addChild(internal2)
        XCTAssertNil(root.leaf(at: 4))
    }
    
    func testLeafAtIndexValidSingleDepth() {
        let parent = TreeNode()
        let child1 = TreeNode()
        let child2 = TreeNode()
        parent.addChildren([child1, child2])
        XCTAssert(parent.leaf(at: 1) === child2)
    }
    
    func testLeafAtIndexValidMultipleDepth() {
        let root = TreeNode()
        let internal1 = TreeNode()
        let leaf1 = TreeNode()
        let leaf2 = TreeNode()
        internal1.addChildren([leaf1, leaf2])
        let internal2 = TreeNode()
        let leaf3 = TreeNode()
        let leaf4 = TreeNode()
        internal2.addChildren([leaf3, leaf4])
        root.addChildren([internal1, internal2])
        XCTAssert(root.leaf(at: 3) === leaf4)
    }
    
    func testIsRootTrueSingleNode() {
        let root = TreeNode()
        XCTAssert(root.isRoot)
    }
    
    func testIsRootTrueContainer() {
        let root = TreeNode()
        root.addChildren([TreeNode(), TreeNode(), TreeNode()])
        XCTAssert(root.isRoot)
    }
    
    func testIsLeafTrueRoot() {
        let root = TreeNode()
        XCTAssert(root.isLeaf)
    }
    
    func testIsLeafTrueLeaf() {
        let root = TreeNode()
        let child = TreeNode()
        root.addChild(child)
        XCTAssert(child.isLeaf)
    }
    
    func testIsLeafFalse() {
        let root = TreeNode()
        let child = TreeNode()
        root.addChild(child)
        XCTAssertFalse(root.isLeaf)
    }
    
    func testIsContainerTrue() {
        let root = TreeNode()
        let child = TreeNode()
        root.addChild(child)
        XCTAssert(root.isContainer)
    }
    
    func testRootSelfSingleNode() {
        let root = TreeNode()
        XCTAssert(root.root === root)
    }
    
    func testRootOnlyChild() {
        let root = TreeNode()
        let child = TreeNode()
        root.addChild(child)
        XCTAssert(child.root === root)
    }
    
    func testRootGrandchild() {
        let root = TreeNode()
        let child = TreeNode()
        let grandchild = TreeNode()
        child.addChild(grandchild)
        root.addChild(child)
        XCTAssert(grandchild.root === root)
    }
    
    func testIsContainerFalse() {
        let root = TreeNode()
        let child = TreeNode()
        root.addChild(child)
        XCTAssertFalse(child.isContainer)
    }
    
    func testPathToRootSingleNode() {
        let root = TreeNode()
        XCTAssert(root.pathToRoot == [root])
    }
    
    func testPathToRootOnlyChild() {
        let root = TreeNode()
        let child = TreeNode()
        root.addChild(child)
        XCTAssert(child.pathToRoot == [child, root])
    }
    
    func testPathToRootGrandchild() {
        let root = TreeNode()
        let child = TreeNode()
        let grandchild = TreeNode()
        child.addChild(grandchild)
        root.addChild(child)
        XCTAssert(grandchild.pathToRoot == [grandchild, child, root])
    }
    
    func testHasAncestorSingleNode() {
        let root = TreeNode()
        XCTAssertFalse(root.hasAncestor(root))
    }
    
    func testHasAncestorOnlyChild() {
        let root = TreeNode()
        let child = TreeNode()
        root.addChild(child)
        XCTAssert(child.hasAncestor(root))
    }
    
    func testHasAncestorGrandchild() {
        let root = TreeNode()
        let child = TreeNode()
        let grandchild = TreeNode()
        child.addChild(grandchild)
        root.addChild(child)
        XCTAssert(grandchild.hasAncestor(root))
        XCTAssert(child.hasAncestor(root))
    }
    
    func testAncestorAtDistanceSingleValid() {
        let root = TreeNode()
        XCTAssert(root.ancestor(at: 0) === root)
    }
    
    func testAncestorAtDistanceSingleNil() {
        let root = TreeNode()
        XCTAssertNil(root.ancestor(at: 1))
    }
    
    func testAncestorAtDistanceOnlyChild() {
        let root = TreeNode()
        let child = TreeNode()
        root.addChild(child)
        XCTAssert(child.ancestor(at: 1) === root)
    }
    
    func testAncestorAtDistanceGrandchild() {
        let root = TreeNode()
        let child = TreeNode()
        let grandchild = TreeNode()
        child.addChild(grandchild)
        root.addChild(child)
        XCTAssert(grandchild.ancestor(at: 1) === child)
        XCTAssert(grandchild.ancestor(at: 2) === root)
    }
    
    func testDepthRoot_1() {
        let root = TreeNode()
        XCTAssertEqual(root.depth, 0)
    }
    
    func testDepthOnlyChild_1() {
        let root = TreeNode()
        let child = TreeNode()
        root.addChild(child)
        XCTAssertEqual(child.depth, 1)
    }
    
    func testDepthGrandchild_2() {
        let root = TreeNode()
        let child = TreeNode()
        let grandchild = TreeNode()
        child.addChild(grandchild)
        root.addChild(child)
        XCTAssertEqual(grandchild.depth, 2)
    }
    
    func testHeightSingleNode_0() {
        let root = TreeNode()
        XCTAssertEqual(root.height, 0)
    }
    
    func testHeightParent_1() {
        let parent = TreeNode()
        parent.addChild(TreeNode())
        XCTAssertEqual(parent.height, 1)
    }
    
    func testHeightGrandparent_2() {
        let grandparent = TreeNode()
        let parent = TreeNode()
        parent.addChild(TreeNode())
        grandparent.addChild(parent)
        XCTAssertEqual(grandparent.height, 2)
        XCTAssertEqual(parent.height, 1)
    }
    
    func testUnbalancedGrandParent_2() {
        let grandparent = TreeNode()
        let parent1 = TreeNode()
        let parent2 = TreeNode()
        parent1.addChild(TreeNode())
        grandparent.addChild(parent1)
        grandparent.addChild(parent2)
        XCTAssertEqual(grandparent.height, 2)
        XCTAssertEqual(parent2.heightOfTree, 2)
    }
    
    func testHasDescendentFalseSingleNode() {
        let root = TreeNode()
        let other = TreeNode()
        XCTAssertFalse(root.hasDescendent(other))
    }
    
    func testHasDescendentParent() {
        let parent = TreeNode()
        let child = TreeNode()
        parent.addChild(child)
        XCTAssert(parent.hasDescendent(child))
        XCTAssertFalse(child.hasDescendent(parent))
    }
    
    func testHasDescendentGrandparent() {
        let grandparent = TreeNode()
        let parent = TreeNode()
        let child = TreeNode()
        parent.addChild(child)
        grandparent.addChild(parent)
        XCTAssert(grandparent.hasDescendent(child))
        XCTAssertFalse(child.hasDescendent(grandparent))
    }
    
    func testLeafAtIndexNilNoLeaves() {
        let root = TreeNode()
        XCTAssertNil(root.leaf(at: 2))
    }
}
