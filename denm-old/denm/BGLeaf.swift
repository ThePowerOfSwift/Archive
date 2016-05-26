import QuartzCore
import UIKit

/**
BGLeaf (BeamGroupLeaf) is a single graphical event-in-time. Contained in BGContainer.
*/
class BGLeaf {
    
    // MARK: Model Context
    
    /// SpanNode containing musical information (has no child spans)
    var spanLeaf: SpanNode?
    
    // MARK: Size
    
    /// Graphical height of a single Guidonian staff space
    var g: CGFloat = 0
    
    /// Levels embedded in tuplet
    var depth: Int = 0
    
    /// If BGLeaf is rest
    var isRest: Bool { get { return spanLeaf!.isRest } }
    
    // MARK: View Context
    
    /// Container
    var bgContainer: BGContainer?
    
    /// Amount of Augmentation Dots (if mensural notation)
    var amountAugmentationDots: Int { get { return getAmountAugmentationDots() } }
    
    // MARK: References to objects
    
    /// Line connecting BeamJunction (in BGContainer) and GraphEvent(s) associated to BGLeaf
    var stem: Stem?
    
    /// Collection of GraphEvents
    var graphEvents: [GraphEvent] = []
    
    // MARK: Position
    
    /**
    Orientation of BGLeaf
    
    - +1: Stems-down
    - -1: Stems-up
    - +0: Neutral
    */
    var o: CGFloat = 1
    
    /// Cumulative graphical distance from start of containing BGContainer
    var xInContainer: CGFloat = 0
    
    /// Cumulative graphical distance from start of containing BeamGroup
    var xInBeamGroup: CGFloat = 0
    
    /// Y-value of stem
    var stemInfoEndY: CGFloat = 0
    
    // perhaps these are not necessary?
    var graphEventsMinY: CGFloat = 0 // change to getter
    var graphEventsMaxY: CGFloat = 0 // change to getter
    
    // MARK: Create a BGLeaf
    
    init() {}
    
    // MARK: Incrementally build a BGLeaf
    
    /**
    Set SpanLeaf
    
    :param: spanLeaf SpanNode
    
    :returns: Self: BGLeaf
    */
    func setSpanLeaf(spanLeaf: SpanNode) -> BGLeaf {
        self.spanLeaf = spanLeaf
        return self
    }
    
    /**
    Set BGContainer
    
    :param: bgContainer BGContainer
    
    :returns: Self: BGLeaf
    */
    func setContainer(bgContainer: BGContainer) -> BGLeaf {
        self.bgContainer = bgContainer
        return self
    }
    
    /**
    Set size with Guidonian staff space scale
    
    :param: g Graphical height of a single Guidonian staff space
    
    :returns: Self: BGLeaf
    */
    func setSize(#g: CGFloat) -> BGLeaf {
        self.g = g
        return self
    }
    
    /**
    Set orientation of BGLeaf
    
    :param: orientation Stems-up / Stems-down / Neutral
    
    :returns: Self: BGLeaf
    */
    func setOrientation(orientation: CGFloat) -> BGLeaf {
        self.o = orientation
        return self
    }
    
    /**
    Set depth of BGLeaf
    
    :param: depth Levels embedded in tuplet
    
    :returns: Self: BGLeaf
    */
    func setDepth(depth: Int) -> BGLeaf {
        self.depth = depth
        return self
    }
    
    /**
    Set stem for reference
    
    :param: stem Line connecting BeamJunction of BGContainer and GraphEvent(s)
    
    :returns: Self: BGLeaf
    */
    func setStem(stem: Stem) -> BGLeaf {
        self.stem = stem
        return self
    }

    /**
    Set X in Container
    
    :param: x Cumulative distance from left of BGContainer
    
    :returns: Self: BGLeaf
    */
    func setXInContainer(x: CGFloat) -> BGLeaf {
        self.xInContainer = x
        return self
    }
    
    /**
    Set X in BeamGroup
    
    :param: x Cumulative distance from left of BeamGroup
    
    :returns: Self: BGLeaf
    */
    func setXInBeamGroup(x: CGFloat) -> BGLeaf {
        self.xInBeamGroup = x
        return self
    }
    
    /**
    Add Stem to BGLeaf
    */
    func addStem() {
        if graphEvents.count > 0 {
            var type: String = isRest ? "rest" : "ord"
            let stem: Stem = CreateStem().withType(type)!
                .setX(xInContainer)
                .setBeamEndY(bgContainer!.beams.frame.minY)
                .setInfoEndY(getStemInfoEndY()) // multiply by orientation
                .setWidth(0.0618 * g) // make not hardcoded!
                .setColor(getColorByDepth(depth))
            if let stemRest = stem as? StemRest {
                stemRest.setStemletLength(getStemletLength())
            }
            stem.build()
            setStem(stem)
            bgContainer!.addSublayer(stem)
        }
    }
    
    /**
    Add GraphEvent
    
    :param: graphEvent Musical material on Graph linked to this BGLeaf
    
    :returns: Self: BGLeaf
    */
    func addGraphEvent(graphEvent: GraphEvent) -> BGLeaf {
        graphEvent.setBGLeaf(self)
        graphEvents.append(graphEvent)
        return self
    }
    
    func getIsRest() -> Bool {
        return spanLeaf!.isRest
    }
    
    // Private?
    func getStemletLength() -> CGFloat {
        let subdLevel: Int = spanLeaf!.duration.subdivisionLevel
        let length: CGFloat = bgContainer!.beams.getBeamHeightWithSubdivisionLevel(subdLevel)
        return length
    }
    
    func getStemInfoEndY() -> CGFloat {
        var stemInfoEndY: CGFloat = 0
        switch o {
        case 1: stemInfoEndY = getStemInfoEndYBelow()
        default: stemInfoEndY = getStemInfoEndYAbove()
        }
        return stemInfoEndY
    }
    
    func getStemInfoEndYBelow() -> CGFloat {
        let furthestGraphEventBelow = getFurthestGraphEventBelow()!
        let bgStratum = bgContainer!.beamGroup!.bgStratum!
        let graph = furthestGraphEventBelow.graph!
        let bgStratumHeight = bgStratum.frame.height
        let displacement = graph.frame.minY - bgStratum.frame.maxY
        let localInfoHeight = furthestGraphEventBelow.maxInfoY
        let stemInfoEndYBelow: CGFloat = bgStratumHeight + displacement + localInfoHeight
        return stemInfoEndYBelow
    }
    
    func getStemInfoEndYAbove() -> CGFloat {
        let furthestGraphEventAbove = getFurthestGraphEventAbove()!
        let bgStratum = bgContainer!.beamGroup!.bgStratum!
        let graph = furthestGraphEventAbove.graph!
        let displacement = bgStratum.frame.minY - graph.frame.maxY
        let localInfoHeight = furthestGraphEventAbove.minInfoY
        let stemInfoEndYAbove = -(displacement + localInfoHeight)
        return stemInfoEndYAbove
    }

    func getFurthestGraphEventAbove() -> GraphEvent? {
        var furthestAbove: GraphEvent?
        for graphEvent in graphEvents {
            if furthestAbove == nil { furthestAbove = graphEvent }
            else if graphEvent.graph!.frame.maxY < furthestAbove!.graph!.frame.maxY {
                furthestAbove = graphEvent
            }
        }
        return furthestAbove
    }
    
    func getFurthestGraphEventBelow() -> GraphEvent? {
        var furthestBelow: GraphEvent?
        for graphEvent in graphEvents {
            if furthestBelow == nil { furthestBelow = graphEvent }
            else if graphEvent.graph!.frame.minY > furthestBelow!.graph!.frame.minY {
                furthestBelow = graphEvent
            }
        }
        return furthestBelow
    }
    
    func getAmountAugmentationDots() -> Int {
        // convert to switch/case control flow
        let beats = spanLeaf!.duration.beats.amount
        if beats % 3 == 0 { return 1 }
        else if beats % 7 == 0 { return 2 }
        else if beats % 15 == 0 { return 3 }
        else { return 0 }
    }
}