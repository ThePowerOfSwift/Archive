//
//  LayoutNode.swift
//  LayoutTools
//
//  Created by James Bean on 6/10/16.
//
//

import QuartzCore
import TreeTools

/// Wrapper for a CALayer, managing automated layout
public final class LayoutNode: NodeType {
    
    // MARK: - Instance Properties
    
    /// Content layer controlled by this `LayoutNode`.
    public let layer: CALayer
    
    /// Parent `LayoutNode`, if present. Otherwise, `nil`.
    public var parent: LayoutNode?
    
    /// Children `LayoutNode` objects.
    public var children: [LayoutNode] = []
    
    /// The direction to flow child `LayoutNode` objects horizontally.
    public var horizontalAlignment: HorizontalLayoutPosition = .none
    
    /// The direction to flow child `LayoutNode` objects vertically.
    public var verticalAlignment: VerticalLayoutPosition = .none
    
    /// The origin from which to stack child `LayoutNode` objects horizontally.
    public var horizontalStackOrigin: HorizontalLayoutPosition = .none
    
    /// The origin from which to stack child `LayoutNode` objects vertically.
    public var verticalStackOrigin: VerticalLayoutPosition = .none
    
    /// Whether or not to calculate the width of `layer` with those of the children.
    public var setsWidthWithChildren: Bool = true
    
    /// Whether or not to calculate the height of `layer` with those of the children.
    public var setsHeightWithChildren: Bool = true

    /// Contains values for top, bottom, left, right padding values.
    public var padding = Padding()
    
    /// Frame of `LayoutNode`. Updates the `frame` property of the `layer` object.
    internal var frame: CGRect = CGRect.zero {
        didSet {
            layer.frame = frame
        }
    }

    // Frame for this `LayoutNode` stored in the layout process before being committed
    internal lazy var frameForLayout: CGRect = { return self.frame }()
    
    // Stored positions calculated for each child `LayoutNode` before moving them
    internal var frameByChild: [LayoutNode: CGRect] = [:]

    // MARK: - Initializers

    /**
     Create a `LayoutNode` with a given `layer` and layout configuration.
     */
    public init(
        _ layer: CALayer = CALayer(),
        stackingVerticallyFrom verticalStackOrigin: VerticalLayoutPosition = .none,
        stackingHorizontallyFrom horizontalStackOrigin: HorizontalLayoutPosition = .none,
        aligningVerticallyTo verticalAlignment: VerticalLayoutPosition = .none,
        aligningHorizontallyTo horizontalAlignment: HorizontalLayoutPosition = .none
    )
    {
        self.layer = layer
        self.frame = layer.frame
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.verticalStackOrigin = verticalStackOrigin
        self.horizontalStackOrigin = horizontalStackOrigin
        layer.drawsAsynchronously = true
    }
    
    // MARK: - Position
    
    /**
     - warning: Not yet implemented!
     */
    public func move(to origin: CGPoint, animated: Bool = false) {
        fatalError()
    }
    
    /**
     - warning: Not yet implemented!
     */
    public func move(
        horizontallyBy tx: CGFloat = 0,
        verticallyBy ty: CGFloat = 0,
        animated: Bool = false
    )
    {
        fatalError()
    }
}

extension LayoutNode: Equatable { }

public func == (lhs: LayoutNode, rhs: LayoutNode) -> Bool {
    return lhs.layer === rhs.layer
}

extension LayoutNode: Hashable {
    
    public var hashValue: Int { return layer.hashValue }
}
