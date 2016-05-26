//
//  GraphEvent.swift
//  DNM_iOS
//
//  Created by James Bean on 8/26/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit
import DNMModel

public class GraphEvent: CALayer {
    
    /// String representation of `GraphEvent`
    public override var description: String { return getDescription() }
    
    /// Identifier of `GraphEvent` (identifier of the target `GraphLayer`)
    public var identifier: GraphID!
    
    public var instrumentEvent: InstrumentEvent?
    
    /// `DurationNode Leaf` containing only the `Components` for a particular `Instrument`
    internal var leaf: DurationNode!
    
    /// Horizontal placement of `GraphEvent`
    internal var x: CGFloat!
    
    /// Graphical width of the `Duration` of `GraphEvent`
    internal var width: CGFloat!

    /// Graphical scale of graphical objects contained by `GraphEvent`
    internal var scale: Scale = 1.0
    
    /// `StemDirection` of `GraphEvent`
    internal var stemDirection: StemDirection = .Down
    
    /// `Articulations` contained by `GraphEvent`
    internal var articulations: [Articulation] = []
    
    /**
    Vertical position of connection point of slur, if necessary
    - Note: Calculated as a byproduct of `Articulation` positioning, 
            though this should be reconsidered
    */
    public var slurConnectionY: CGFloat = 0
    
    /// Vertical position at which to place the end of a `Stem`
    public var stemEndY: CGFloat { get { return getStemEndY() } }
    
    /// Greatest vertical position of musical information in `GraphEvent`
    public var maxInfoY: CGFloat { get { return getMinInfoY() } }
    
    /// Least vertical position of musical information in `GraphEvent`.
    public var minInfoY: CGFloat { get { return getMaxInfoY() } }
    
    /// Greatest vertical position of any graphical elements in `GraphEvent`
    public var maxY: CGFloat { get { return getMaxY() } }
    
    /// Least vertical position of any graphical elements in `GraphEvent`
    public var minY: CGFloat { get { return getMinY() } }
    
    /**
    Order in which to stack `Articulations`, from inside to out
    - Note: `Articulation` stacking needs to be refactored to its own class. 
            The stacking order should be held there.
    */
    public static var articulationStackingOrder: [ArticulationType] = [
        .Staccato, .Accent, .Tenuto
    ]
    
    public class func with(type: GraphEventType,
        identifier: GraphID,
        leaf: DurationNode,
        x: CGFloat,
        width: CGFloat,
        stemDirection: StemDirection,
        scale: Scale
    ) -> GraphEvent
    {
        var classType: GraphEvent.Type {
            switch type {
            case .Node: return GraphEventNode.self
            case .Edge: return GraphEventEdge.self // TODO: implement GraphEventEdge
            case .Staff: return StaffEvent.self
            }
        }
        return classType.init(
            identifier: identifier,
            leaf: leaf, 
            x: x,
            width: width,
            stemDirection: stemDirection,
            scale: scale
        )
    }
    
    public required init(
        identifier: GraphID = "graph",
        leaf: DurationNode,
        x: CGFloat,
        width: CGFloat,
        stemDirection: StemDirection,
        scale: Scale
    )
    {
        self.identifier = identifier
        self.leaf = leaf
        self.x = x
        self.width = width
        self.stemDirection = stemDirection
        self.scale = scale
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    public func addComponent(component: Component) {
        // something; override
    }
    
    public func addArticulationWithType(type: ArticulationType) {
        
        // TODO: scale g
        if let articulation = Articulation.withType(type, x: 0, y: 0, g: 12) {
            addArticulation(articulation)
        }
    }
    
    public func addArticulation(articulation: Articulation) {
        articulations.append(articulation)
        addSublayer(articulation)
    }
    
    public func clear() {
        sublayers = []
    }
    
    public func build() {
        moveArticulations()
        setFrame()
    }
    
    internal func setFrame() {
        position.x = x
    }
    
    // TODO: Refactor into own class: ArticulationMover()
    // FIXME: check positioning of articulations for generic graph
    internal func moveArticulations() {
        sortArticulationsByType()
        let yRef: CGFloat = stemDirection == .Down ? maxInfoY : minInfoY
        let dir: CGFloat = stemDirection == .Down ? 1 : -1
        let ΔY: CGFloat = 7.5
        var y = yRef + 1.618 * ΔY * dir
        for articulation in articulations {
            articulation.position.y = y
            articulation.position.x = 0.5 * frame.width
            y += ΔY * dir
        }
        slurConnectionY = y
    }
    
    internal func getMaxInfoY() -> CGFloat {
        return 0.5 * frame.height
    }
    
    internal func getMinInfoY() -> CGFloat {
        return 0.5 * frame.height
    }
    
    internal func getMinY() -> CGFloat {
        return 0.5 * frame.height
    }
    
    internal func getMaxY() -> CGFloat {
        return 0.5 * frame.height
    }
    
    private func getStemEndY() -> CGFloat {
        switch stemDirection {
        case .Up: return minInfoY
        case .Down: return maxInfoY
        }
    }
    
    // TODO: refactor into own class: ArticulationSorter
    internal func sortArticulationsByType() {
        var articulations_sorted: [Articulation] = []
        for articulationType in GraphEvent.articulationStackingOrder {
            switch articulationType {
            case .Staccato:
                for articulation in articulations {
                    if articulation is ArticulationStaccato {
                        articulations_sorted.append(articulation)
                    }
                }
            case .Accent:
                for articulation in articulations {
                    if articulation is ArticulationAccent {
                        articulations_sorted.append(articulation)
                    }
                }
            case .Tenuto:
                for articulation in articulations {
                    if articulation is ArticulationTenuto {
                        articulations_sorted.append(articulation)
                    }
                }
            default: break
            }
        }
        let complement = articulations.filter { !articulations_sorted.contains($0) }
        articulations = articulations_sorted + complement
    }
    
    internal func getDescription() -> String {
        return "GraphEvent: \(identifier)"
    }
}