import UIKit
import QuartzCore

/**
Graph: This is the base-class for all information-bearing graphs:

- Staff
- String Tablature
- Anything
*/
class Graph: Stratum {
    
    // MARK: Attributes
    
    /// ID of Graph
    var id: String = ""
    
    /// Length of break in Graph lines for new clef: discussion / images needed
    var newClefDisplaceX: CGFloat = 0
    
    // MARK: Components
    
    /// All GraphEvents in Graph
    var events: [GraphEvent] = []
    
    /// Layer containing all Clefs in Graph
    let clefsLayer: ClefsLayer = ClefsLayer()
    
    // articulations layer?
    
    // MARK: Create a Graph
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    override init!() { super.init() }
    
    // MARK: Incrementally build a Graph
    
    /**
    Set ID of Graph
    
    :param: id ID of Graph
    
    :returns: Self: Graph
    */
    func setID(id: String) -> Graph {
        self.id = id
        return self
    }
    
    /**
    Set top of Graph
    
    :param: top Top of Graph
    
    :returns: Self: Graph
    */
    func setTop(top: CGFloat) -> Graph {
        self.top = top
        return self
    }
    
    
    func setGraphTop(top: CGFloat) -> Graph {
        
        return self
    }
    
    // MARK: Start / Stop Lines
    
    func startLinesAt(#x: CGFloat) -> Graph {
        
        return self
    }
    
    func stopLinesAt(#x: CGFloat) -> Graph {
        
        return self
    }
    
    /**
    Add Clef at desired x-value
    
    :param: type Type of Clef
    :param: x    x-value
    
    :returns: Self: Graph
    */
    func addClef(type: String, x: CGFloat) -> Graph {
        if clefsLayer.clefs.count > 0 { stopLinesAt(x: x - newClefDisplaceX) }
        startLinesAt(x: x)
        let clef: Clef = CreateClef().withType(type)!.setX(x)
        clefsLayer.addClef(clef)
        return self
    }
    
    // MARK: Events
    
    /**
    Start GraphEvent at desired x-value
    
    :param: x x-value
    
    :returns: Self: Graph
    */
    func startNewEventAt(x: CGFloat) -> Graph {
        /* override in Staff to cast GraphEvent to StaffEvent */
        let event: GraphEvent = GraphEvent(x: x)
        events.append(event)
        return self
    }
    
    /**
    Set GraphEvent at desired x-value, linked to BGLeaf
    
    :param: x      x-value
    :param: bgLeaf BGLeaf
    */
    func startNewEventAtX(#x: CGFloat, bgLeaf: BGLeaf) {
        
    }
    
    /**
    Get current event
    
    :returns: Current GraphEvent
    */
    func getCurrentEvent() -> GraphEvent {
        return events.last!
    }
    
    func rest() {
        /* override */
    }
    
    /**
    Overrides Stratum.moveTo(x:y:)
    
    :param: x x-value
    :param: y y-value
    */
    override func moveTo(#x: CGFloat, y: CGFloat) {
        position.y = y + 0.5 * frame.height
        
        // encapsulate!
        
        CATransaction.setDisableActions(true)
        for event in events {
            let bgLeaf: BGLeaf = event.bgLeaf!
            let stem: Stem? = bgLeaf.stem
            stem?.setInfoEndY(event.bgLeaf!.getStemInfoEndY()).rebuild()
        }
        CATransaction.setDisableActions(false)
    }
    
    /**
    Sets size and position of Graph
    
    :returns: Self: Graph
    */
    func build() -> Graph {
        setFrame()
        return self
    }
    
    override func setFrame() {
        frame = CGRectMake(0, 0, width, height)
        setExternalPads()
    }
    
    override func setExternalPads() {
        externalPads.setBottom(10)
    }
}