import UIKit
import QuartzCore

/**
Staff: 5-line Guidonian representation of Pitch
*/
class Staff: Graph {
    
    // MARK: Size

    /// Graphical height of a single Guidonian staff space
    var g: CGFloat = 0
    
    // MARK: Position
    
    var staffTop: CGFloat = 0
    var staffDisplaceFromTop: CGFloat = 0
    var middleCStaffSpace: CGFloat = 0
    
    // MARK: Sublayers
    
    let linesLayer: StaffLinesLayer = StaffLinesLayer()
    let infoLayer: StaffInfoLayer = StaffInfoLayer()

    // MARK: Create a Staff
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build a Staff
    
    /**
    Set size
    
    :param: g Graphical height of a single Guidonian staff space
    
    :returns: Self: Staff
    */
    func setSize(#g: CGFloat) -> Staff {
        self.g = g
        self.height = 4 * g
        linesLayer.setSize(g)
        newClefDisplaceX = 0.618 * g
        return self
    }
    
    /**
    Set top
    
    :param: top Graphical top
    
    :returns: Self: Staff
    */
    override func setTop(top: CGFloat) -> Staff {
        self.top = top
        return self
    }
    
    
    func setStaffTop(top: CGFloat) -> Staff {
        self.staffTop = top
        return self
    }
    
    // MARK: Add Lines to Staff
    
    /**
    Start lines at desired x-value
    
    :param: x Horizontal point to begin lines
    
    :returns: Self: Staff
    */
    override func startLinesAt(#x: CGFloat) -> Staff {
        startStaffLinesAt(x: x)
        return self
    }
    
    /**
    Stop lines at desired x-value
    
    :param: x Horizontal point to end lines
    
    :returns: Self: Staff
    */
    override func stopLinesAt(#x: CGFloat) -> Staff {
        stopStaffLinesAt(x: x)
        return self
    }
    
    /**
    Start staff lines at desired x-value
    
    :param: x Horizontal point to start staff lines
    
    :returns: Self: Staff
    */
    func startStaffLinesAt(#x: CGFloat) -> Staff {
        linesLayer.startStaffLinesAt(x: x)
        return self
    }
    
    /**
    Stop staff lines at desired x-value
    
    :param: x Horizontal point to stop staff lines
    
    :returns: Self: Staff
    */
    func stopStaffLinesAt(#x: CGFloat) -> Staff {
        linesLayer.stopStaffLinesAt(x: x)
        return self
    }
    
    func ledgerLinesAbove(amount: Int, x: CGFloat) -> Staff {
        if amount > 0 { for level in 1...amount { linesLayer.ledgerLineOnLevel(+level, x: x) } }
        return self
    }
    
    func ledgerLinesBelow(amount: Int, x: CGFloat) -> Staff {
        if amount > 0 { for level in 1...amount { linesLayer.ledgerLineOnLevel(-level, x: x) } }
        return self
    }
    
    // MARK: Add Clefs to Staff
    
    // down the line, probably don't need to override this:
    // get middleCStaffSpace when adding notehead: clefsLayer.clefs.last!.middleCStaffSpace
    override func addClef(type: String, x: CGFloat) -> Staff {
        if clefsLayer.clefs.count > 0 { stopLinesAt(x: x - newClefDisplaceX) }
        startLinesAt(x: x)
        let clef: Clef = CreateStaffClef().withType(type, transposition: 0)!
            .setX(x)
            .build()
        clefsLayer.addClef(clef)
        if let sClef = clef as? StaffClef { middleCStaffSpace = sClef.middleCStaffSpace }
        return self
    }
    
    // MARK: Add Events to Staff
    
    /**
    Get current Staff Event
    
    :returns: StaffEvent: current staff event
    */
    override func getCurrentEvent() -> StaffEvent {
        return events.last! as StaffEvent
    }
    
    
    /**
    Start new event at desired x-value
    
    :param: x Horizontal point to add new musical event on staff
    
    :returns: Self: Staff
    */
    override func startNewEventAt(x: CGFloat) -> Staff {
        let newEvent: StaffEvent = StaffEvent(x: x).setGraph(self)
        events.append(newEvent)
        return self
    }
    
    /**
    Start new event at desired x-value, with BGLeaf
    
    :param: x      Horizontal point to add new Staff Event
    :param: bgLeaf BGLeaf (Beam Group Leaf)
    
    :returns: Self: Staff
    */
    func startNewEventAt(x: CGFloat, bgLeaf: BGLeaf) -> Staff {
        // is this the right place to setBGLeaf?
        let newEvent: StaffEvent = StaffEvent(x: x)
            .setGraph(self)
            .setBGLeaf(bgLeaf)
        events.append(newEvent)
        return self
    }
    
    /**
    Add pitch to current event
    
    :param: pitch Pitch
    
    :returns: Self: Staff
    */
    func addPitchToCurrentEvent(#pitch: Pitch) -> Staff {
        let currentEvent: StaffEvent = events.last! as StaffEvent
        currentEvent.addPitch(pitch)
        return self
    }
    
    func addPitchesToCurrentEvent(#pitches: [Float]) -> Staff {
        for pitch in pitches { addPitchToCurrentEvent(pitch: Pitch(midi: pitch)) }
        return self
    }
    
    func addArticulationToCurrentEvent(#articulation: Articulation) -> Staff {
        let currentEvent: StaffEvent = events.last! as StaffEvent
        currentEvent.addArticulation(articulation)
        return self
    }
    
    func startSlurAtCurrentEvent() -> Staff {
        let currentEvent: StaffEvent = events.last! as StaffEvent
        currentEvent.startSlur()
        return self
    }
    
    func endSlurAtCurrentEvent() -> Staff {
        let currentEvent: StaffEvent = events.last! as StaffEvent
        currentEvent.endSlur()
        return self
    }
    
    func commitEvent() -> Staff {
        
        return self
    }

    // MARK: Build a Staff
    
    /**
    Adds all neceessary components to Staff layer
    
    :returns: Self: Staff
    */
    override func build() -> Staff {
        addEvents()
        setFrame()
        addLinesLayer()
        addClefsLayer()
        addInfoLayer()
        return self
    }
    
    // this should be done externally
    private func addEvents() {
        // THIS WILL NEED TO CHANGE!
        
        for e in 0..<events.count {
            let event = events[e]
            if let staffEvent = event as? StaffEvent {
                
                staffEvent.spellPitches() // this will move around?
                
                // encapsulate?
                let (noteheads, accidentals) = staffEvent.makeNoteheadsAndAccidentals(
                    g: g,
                    middleCStaffSpace: middleCStaffSpace
                )
                
                infoLayer.noteheads.extend(noteheads)
                infoLayer.accidentals.extend(accidentals)
                let articulations = staffEvent.makeArticulations(g: g)
                infoLayer.articulations.extend(articulations)
                
                // encapsulate?
                let (above, below) = staffEvent.getLedgerLines()
                ledgerLinesAbove(above, x: staffEvent.x)
                ledgerLinesBelow(below, x: staffEvent.x)
            }
        }
    }
    
    private func addLinesLayer() {
        linesLayer.build()
        addSublayer(linesLayer)
    }
    
    private func addClefsLayer() {
        clefsLayer.setSize(g, height: 4 * g)
        clefsLayer.setTop(staffDisplaceFromTop)
        clefsLayer.build()
        addSublayer(clefsLayer)
    }
    
    
    private func addInfoLayer() {
        //addTestSlurs()
        
        for event in events {

            if event.endsSlur {
                
                let y: CGFloat = event.getMaxInfoY() - staffDisplaceFromTop
                let slur = infoLayer.slurs.last!
                slur.setEndPoint(CGPointMake(event.x, y)).build()
            }
            if event.startsSlur {
                
                let y: CGFloat = event.getMaxInfoY() - staffDisplaceFromTop
                let slur: Slur = Slur().setStartPoint(CGPointMake(event.x, y))
                infoLayer.slurs.append(slur)
            }
        }
        
        infoLayer.build()
        addSublayer(infoLayer)
    }
    
    override func setWidth() -> Staff {
        var maxWidth: CGFloat = 0
        for pathPoints in linesLayer.staffLinePathPointsOnLevel[0]! {
            maxWidth = pathPoints.stop > maxWidth ? pathPoints.stop : maxWidth
        }
        width = maxWidth
        return self
    }
    
    func setHeight() -> Staff {
        var maxY: CGFloat = 4 * g
        var minY: CGFloat = 0
        for event in events {
            for item in event.items {
                maxY = item.frame.maxY > maxY ? item.frame.maxY : maxY
                minY = item.frame.minY < minY ? item.frame.minY : minY
            }
        }
        staffDisplaceFromTop = abs(minY)
        height = abs(minY) + maxY > 4 * g ? abs(minY) + maxY : 4 * g
        linesLayer.position.y += staffDisplaceFromTop
        infoLayer.position.y += staffDisplaceFromTop
        return self
    }
    
    override func setFrame() {
        setExternalPads()
        setWidth()
        setHeight()
        frame = CGRectMake(left, top, width, height)
    }
    
    override func setExternalPads() {
        externalPads.setBottom(g)
    }
    
    func addLabel(name: String) {
        let labelTop: CGFloat = staffDisplaceFromTop + 1.5 * g
        let label: TextLayerByHeight = TextLayerByHeight()
            .setInfo(name)
            .setSize(1.5 * g, fontName: "Baskerville-SemiBold", alignmentMode: "right")
            .setPosition(clefsLayer.clefs[0].position.x - 10, top: labelTop)
            .setColor(UIColor.blackColor().CGColor)
        addSublayer(label)
    }
}