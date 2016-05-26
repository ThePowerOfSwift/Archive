//
//  ViewNode.swift
//  DNM_iOS
//
//  Created by James Bean on 8/19/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit
import DNMModel

// TODO: major cleaning of
/// Hierarchical orgnization of CALayers, customizable in its layout
public class ViewNode: CALayer {
    
    // MARK: - Layout Configuration
    
    /// Direction from which nodes flow horizontally
    public var flowDirectionHorizontal: LayoutDirectionHorizontal = .None
    
    /// Direction from which nodes flow vertically
    public var flowDirectionVertical: LayoutDirectionVertical = .None
    
    /// Direction from which nodes stack horizontally
    public var stackDirectionHorizontal: LayoutDirectionHorizontal = .None
    
    /// Direction from which nodes stack vertically
    public var stackDirectionVertical: LayoutDirectionVertical = .None
    
    /// If this ViewNode should set its width based on its children ViewNodes
    public var setsWidthWithContents: Bool = true
    
    /// If this ViewNode should set its height based on its children ViewNodes
    public var setsHeightWithContents: Bool = true
    
    // MARK: - Tree Structure
    
    /// ViewNodes contained by this ViewNode
    public var nodes: [ViewNode] = []
    
    /// If this ViewNode contains other ViewNodes
    public var isContainer: Bool { get { return getIsContainer() } }
    
    /// The ViewNode that contains this ViewNode, if any
    public var container: ViewNode?
    
    /// The ViewNode before this ViewNode in its container's nodes array, if any
    public var previous: ViewNode?
    
    /// The ViewNode after this ViewNode in its container's nodes array, if any
    public var next: ViewNode?
    
    // MARK: - Position
    
    /// X value of left edge of ViewNode
    public var left: CGFloat = 0
    
    /// Y value of top edge of ViewNode
    public var top: CGFloat = 0
    
    /// The position of each ViewNode, orgnized by he ViewNode
    public var positionByNode: [ViewNode : CGPoint] = [:]
    
    // MARK: - Graphical Padding
    
    /// Padding between this ViewNode and the one above it
    public var pad_top: CGFloat = 0
    
    /// Padding between this ViewNode and the one below it
    public var pad_bottom: CGFloat = 0
    
    /// Padding between this ViewNode and the one to the left of it
    public var pad_left: CGFloat = 0
    
    /// Padding between this ViewNode and the one to the right of it
    public var pad_right: CGFloat = 0
    
    /**
    Create a ViewNode that stacks vertically from a specified direction

    - parameter stackDirectionVertical: LayoutDirectionVeritcal

    - returns: ViewNode
    */
    public init(stackVerticallyFrom stackDirectionVertical: LayoutDirectionVertical) {
        super.init()
        self.stackDirectionVertical = stackDirectionVertical
        self.drawsAsynchronously = true
    }
    
    /**
    Create a ViewNode that stacks horizontally from a specified direction

    - parameter stackDirectionHorizontal: LayoutDirectionHorizontal

    - returns: ViewNode
    */
    public init(stackHorizontallyFrom stackDirectionHorizontal: LayoutDirectionHorizontal) {
        super.init()
        self.stackDirectionHorizontal = stackDirectionHorizontal
        self.drawsAsynchronously = true
    }
    
    /**
    Create a ViewNode that flows vertically from a specified direction

    - parameter flowDirectionVertical: LayoutDirectionVertical

    - returns: ViewNode
    */
    public init(flowVerticallyFrom flowDirectionVertical: LayoutDirectionVertical) {
        super.init()
        self.flowDirectionVertical = flowDirectionVertical
        self.drawsAsynchronously = true
    }
    
    /**
    Create a ViewNode that flows horizontally from a specified direction

    - parameter flowDirectionHorizontal: LayoutDirectionHorizontal

    - returns: ViewNode
    */
    public init(flowHorizontallyFrom flowDirectionHorizontal: LayoutDirectionHorizontal) {
        super.init()
        self.flowDirectionHorizontal = flowDirectionHorizontal
        self.drawsAsynchronously = true
    }
    
    /**
    Create a ViewNode that flows vertically and horizontally from specified directions

    - parameter flowDirectionVertical:   LayoutDirectionVertical
    - parameter flowDirectionHorizontal: LayoutDirectionHorizontal

    - returns: ViewNode
    */
    public init(
        flowVerticallyFrom flowDirectionVertical: LayoutDirectionVertical,
        flowHorizontallyFrom flowDirectionHorizontal: LayoutDirectionHorizontal
    )
    {
        super.init()
        self.flowDirectionVertical = flowDirectionVertical
        self.flowDirectionHorizontal = flowDirectionHorizontal
        self.drawsAsynchronously = true
    }
    
    /**
    Create a default ViewNode

    - returns: ViewNode
    */
    public override init() {
        super.init()
        self.drawsAsynchronously = true
    }
    
    /**
    Create a ViewNode with NSCoder

    - parameter aDecoder: NSCoder

    - returns: ViewNode
    */
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    /**
    Create a ViewNode with CALayer

    - parameter layer: CALayer

    - returns: ViewNode
    */
    public override init(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: - Add ViewNodes
    
    /**
    Add child ViewNode
    
    - parameter node:         ViewNode to add
    - parameter shouldLayout: If this ViewNode should layout it child ViewNodes
    */
    public func addNode(node: ViewNode, andLayout shouldLayout: Bool = true) {
        if node.container != nil {
            
            // make better
            let point = convertPoint(
                CGPointMake(node.frame.minX, node.frame.minY), fromLayer: node.container!
            )
            node.moveHorizontallyToX(point.x, animated: false)
            
            // consider adding point to positionByNode?
            
            node.container!.removeNode(node, animated: false)
        }
        node.container = self
        nodes.append(node)
        if shouldLayout { layout() }
        addSublayer(node)
    }

    public func removeNode(node: ViewNode, animated: Bool) {
        if !animated { CATransaction.setDisableActions(true) }
        removeNode(node)
        if !animated { CATransaction.setDisableActions(false) }
    }
    
    public func removeNode(node: ViewNode, andLayout shouldLayout: Bool = true) {
        nodes.removeObject(node)
        node.removeFromSuperlayer(animated: false)
        node.container = nil
        if shouldLayout { layout() }
    }
    
    public func hasNode(node: ViewNode) -> Bool {
        let index: Int? = nodes.indexOf(node)
        return index == nil ? false : true
    }
    
    public func removeFromSuperlayer(animated animated: Bool) {
        if !animated { CATransaction.setDisableActions(true) }
        removeFromSuperlayer()
        if !animated { CATransaction.setDisableActions(false) }
    }
    
    public func insertNodes(nodes: [ViewNode], afterNode otherNode: ViewNode) {
        let index: Int? = self.nodes.indexOfObject(otherNode)
        if index == nil { return }
        for n in 0..<nodes.count {
            let node = nodes[n]
            node.container = self
            node.beginTime = 0.075 // eh
            self.nodes.insert(node, atIndex: index! + 1 + n)
        }
        layout()
        for node in nodes {
            CATransaction.setDisableActions(true)
            addSublayer(node)
            CATransaction.setDisableActions(false)
        }
    }
    
    public func insertNodes(nodes: [ViewNode], beforeNode otherNode: ViewNode) {
        
    }
    
    public func insertNodes(nodes: [ViewNode], atIndex index: Int) {
        for n in 0..<nodes.count {
            let node = nodes[n]
            node.container = self
            node.beginTime = 0.075
            self.nodes.insert(node, atIndex: index + n)
        }
        layout()
        
        for node in nodes {
            CATransaction.setDisableActions(true)
            addSublayer(node)
            CATransaction.setDisableActions(false)
        }
    }
    
    
    public func removeNodes(nodes: [ViewNode]) {
        
        for node in nodes {
            self.nodes.removeObject(node)
            node.container = nil
            CATransaction.setDisableActions(true)
            node.removeFromSuperlayer(animated: false)
            CATransaction.setDisableActions(false)
        }
        layout()
    }
    
    public func replaceNode(node: ViewNode, withNode newNode: ViewNode) {
        if let index = nodes.indexOfObject(node) {
            newNode.container = self
            removeNode(node, animated: false)
            insertNode(newNode, atIndex: index)
        }
        return
        
    }
    
    public func insertNode(node: ViewNode,
        beforeNode otherNode: ViewNode, andLayout shouldLayout: Bool = true
        )
    {
        // only use one, and use the other as a public interface
        
        let index: Int? = nodes.indexOfObject(otherNode)
        if index == nil { return }
        
        
        
        node.container = self
        if !hasNode(node) { nodes.insert(node, atIndex: index!) }
        if shouldLayout { layout() }
        CATransaction.setDisableActions(true)
        addSublayer(node)
        CATransaction.setDisableActions(false)
    }
    
    public func insertNode(node: ViewNode,
        afterNode otherNode: ViewNode, andLayout shouldLayout: Bool = true
        )
    {
        let index: Int? = nodes.indexOfObject(otherNode)
        if index == nil { return }
        
        /*
        if node.container != nil {
        let point = convertPoint(
        CGPointMake(node.frame.minX, node.frame.minY), fromLayer: node.container!
        )
        node.moveHorizontallyToX(point.x, animated: false)
        node.container!.removeNode(node, animated: false)
        }
        */
        
        
        node.container = self
        if !hasNode(node) { nodes.insert(node, atIndex: index! + 1) }
        if shouldLayout { layout() }
        CATransaction.setDisableActions(true)
        addSublayer(node)
        CATransaction.setDisableActions(false)
    }
    
    public func insertNode(
        node: ViewNode, atIndex index: Int, andLayout shouldLayout: Bool = true
        )
    {
        node.container = self
        
        if !hasNode(node) { nodes.insert(node, atIndex: index) }
        if shouldLayout { layout() }
        CATransaction.setDisableActions(true)
        addSublayer(node)
        CATransaction.setDisableActions(false)
    }
    
    public func clearNodes() {
        // this is dangerous: iterating over an array while mutating it. Reconsider
        for node in nodes { node.removeFromSuperlayer(animated: false) }
        nodes = []
    }

    
    // MARK - Layout a ViewNode
    
    public func layout() {
        
        CATransaction.setAnimationDuration(0.000001)
        
        if stackDirectionVertical != .None { stackVertically() }
        if stackDirectionHorizontal != .None { stackHorizontally() }
        if flowDirectionVertical != .None { flowVertically() }
        if flowDirectionHorizontal != .None { flowHorizontally() }
        
        if setsHeightWithContents { setHeightWithContents() }
        if setsWidthWithContents { setWidthWithContents() }

        self.container?.layout()
    }
    
    internal func flowVertically() {
        if setsHeightWithContents { setHeightWithContents() }
        switch flowDirectionVertical {
        case .Top:
            for node in nodes {
                node.moveVerticallyToY(0)

                // test
                if positionByNode[node] == nil { positionByNode[node] = CGPointZero }
                positionByNode[node]!.y = 0.5 * node.frame.height
            }
        case .Bottom:
            for node in nodes {
                node.moveVerticallyToY(frame.height - node.frame.height)
                
                // test
                if positionByNode[node] == nil { positionByNode[node] = CGPointZero }
                positionByNode[node]!.y = frame.height - 0.5 * node.frame.height
            }
        case .Middle:
            for node in nodes {
                node.position.y = 0.5 * frame.height
                
                //test
                if positionByNode[node] == nil { positionByNode[node] = CGPointZero }
                positionByNode[node]!.y = 0.5 * frame.height
            }
        default:
            break
        }
    }
    
    internal func flowHorizontally() {
        if setsWidthWithContents { setWidthWithContents() }
        switch flowDirectionHorizontal {
        case .Left:
            for node in nodes {
                node.moveHorizontallyToX(0)
                
                if positionByNode[node] == nil { positionByNode[node] = CGPointZero }
                positionByNode[node]!.x = 0.5 * node.frame.width
            }
        case .Right:
            for node in nodes {
                node.moveHorizontallyToX(frame.width - node.frame.width)
                
                if positionByNode[node] == nil { positionByNode[node] = CGPointZero }
                positionByNode[node]!.x = frame.width - 0.5 * node.frame.width
            }
        case .Center:
            for node in nodes {
                node.position.x = position.x
                
                if positionByNode[node] == nil { positionByNode[node] = CGPointZero }
                positionByNode[node]!.x = position.x
            }
        default: break
        }
    }
    
    internal func stackVertically() {
        if !isContainer { return }
        var accumHeight: CGFloat = 0
        let final: Int = stackDirectionVertical == .Top ? nodes.count - 1 : 0
        var n: Int = stackDirectionVertical == .Top ? 0 : nodes.count - 1
        while true {
            let node = nodes[n]
            
            node.moveVerticallyToY(accumHeight)
            
            // test
            if positionByNode[node] == nil { positionByNode[node] = CGPointZero }
            positionByNode[node]!.y = accumHeight + 0.5 * node.frame.height
            
            accumHeight += node.frame.height
            
            // add pad
            if n != final {
                accumHeight = stackDirectionVertical == .Top
                    ? accumHeight + nodes[n].pad_bottom
                    : accumHeight + nodes[n-1].pad_top
            }
            
            // escape if last
            if n == final { break }
                
                // continue on to next
            else { n = stackDirectionVertical == .Top ? n + 1 : n - 1 }
        }
    }
    
    internal func stackHorizontally() {
        if !isContainer { return }
        var accumWidth: CGFloat = 0
        let final: Int = stackDirectionHorizontal == .Left ? nodes.count - 1 : 0
        var n: Int = stackDirectionHorizontal == .Left ? 0 : nodes.count - 1
        while true {
            let node = nodes[n]
            node.moveHorizontallyToX(accumWidth)
            
            if positionByNode[node] == nil { positionByNode[node] = CGPointZero }
            positionByNode[node]!.x = accumWidth + 0.5 * node.frame.width
            
            
            accumWidth += node.frame.width
            if n != final { accumWidth += node.pad_right }
            if n == final { break }
            else { n = stackDirectionHorizontal == .Left ? n + 1 : n - 1 }
        }
    }
    
    // MARK: - Position ViewNode
    
    public func moveBy(ΔX: CGFloat, ΔY: CGFloat, animated: Bool) {
        moveBy(ΔX: ΔX, ΔY: ΔY)
    }
    
    public func moveBy(ΔX ΔX: CGFloat, ΔY: CGFloat) {
        position.x += ΔX
        position.y += ΔY
    }
    
    public func moveHorizontallyByX(ΔX: CGFloat, animated: Bool) {
        CATransaction.setDisableActions(true)
        moveHorizontallyByX(ΔX)
        CATransaction.setDisableActions(false)
    }
    
    public func moveHorizontallyByX(ΔX: CGFloat) {
        CATransaction.setDisableActions(true)
        position.x += ΔX
        CATransaction.setDisableActions(false)
    }
    
    public func moveVerticallyByY(ΔY: CGFloat, animated: Bool) {
        CATransaction.setDisableActions(true)
        moveVerticallyByY(ΔY)
        CATransaction.setDisableActions(false)
    }
    
    public func moveVerticallyByY(ΔY: CGFloat) {
        position.y += ΔY
    }
    
    public func moveHorizontallyToX(x: CGFloat, animated: Bool) {
        CATransaction.setDisableActions(true)
        moveHorizontallyToX(x)
        CATransaction.setDisableActions(false)
    }
    
    public func moveVerticallyToY(y: CGFloat, animated: Bool) {
        if !animated { CATransaction.setDisableActions(true) }
        moveVerticallyToY(y)
        if !animated { CATransaction.setDisableActions(false) }
    }
    
    public func moveVerticallyToY(y: CGFloat) {
        if superlayer == nil { CATransaction.setDisableActions(true) }
        position.y = y + 0.5 * frame.height
        if superlayer == nil { CATransaction.setDisableActions(false) }
        self.top = y
    }
    
    public func moveHorizontallyToX(x: CGFloat) {
        
        CATransaction.setDisableActions(true)
        frame = CGRectMake(x, frame.minY, frame.width, frame.height)
        CATransaction.setDisableActions(false)
        
        self.left = x
    }
    
    public func moveTo(x x: CGFloat, y: CGFloat, animated: Bool) {
        CATransaction.setDisableActions(true)
        moveTo(x: x, y: y)
        CATransaction.setDisableActions(false)
    }
    
    public func moveTo(x x: CGFloat, y: CGFloat) {
        CATransaction.setDisableActions(true)
        position.x = x + 0.5 * frame.width
        position.y = y + 0.5 * frame.height
        CATransaction.setDisableActions(false)
    }
    
    public func moveTo(point point: CGPoint, animated: Bool) {
        CATransaction.setDisableActions(true)
        moveTo(point: point)
        CATransaction.setDisableActions(false)
    }
    
    public func moveTo(point point: CGPoint) {
        CATransaction.setDisableActions(true)
        position.x = point.x + 0.5 * frame.width
        position.y = point.y + 0.5 * frame.width
        CATransaction.setDisableActions(false)
    }
    
    internal func setHeightWithContents() {
        if !isContainer { return }
        let minY = nodes.sort { $0.frame.minY < $1.frame.minY }.first?.frame.minY
        let maxY = nodes.sort { $0.frame.maxY > $1.frame.maxY }.first?.frame.maxY
        if let minY = minY, maxY = maxY {
            let height = maxY - minY
            CATransaction.setDisableActions(true)
            frame = CGRectMake(left, top, frame.width, height)
            CATransaction.setDisableActions(false)
        }
    }
    
    internal func setWidthWithContents() {
        if !isContainer { return }
        let minX = nodes.sort { $0.frame.minX < $1.frame.minX }.first?.frame.minX
        let maxX = nodes.sort { $0.frame.maxX > $1.frame.maxX }.first?.frame.maxX
        if let minX = minX, maxX = maxX {
            let width: CGFloat
            switch (flowDirectionHorizontal, stackDirectionHorizontal) {
            case (.None, .None): width = maxX
            default: width = maxX - minX
            }
            CATransaction.setDisableActions(true)
            frame = CGRectMake(left, top, width, frame.height)
            CATransaction.setDisableActions(false)
        }
    }
    
    internal func getIsContainer() -> Bool {
        return nodes.count > 0
    }
}