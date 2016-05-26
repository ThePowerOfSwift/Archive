import QuartzCore

/**
SpanComponent Manager: much discussion needed here!
*/
class SpanComponentManager {
    
    // MARK: References to Strata
    
    /// Array of BGStrata (Beam Group Strata)
    var bgStrata: [BGStratum] = []
    
    /// Array of Performers
    var performers: [Performer] = []
    // many more: must all be declared?
    
    /**
    Create an empty SpanComponentManager
    
    :returns: Self: SpanComponentManager
    */
    init() {}
    
    // MARK: Incrementally build a SpanComponentManager
    
    /**
    Set BGStrata of SpanComponentManager
    
    :param: bgStrata BGStrata (Beam Group Strata)
    
    :returns: Self: SpanComponentManager
    */
    func setBGStrata(bgStrata: [BGStratum]) -> SpanComponentManager {
        self.bgStrata = bgStrata
        return self
    }
    
    /**
    Set Performers of SpanComponentManager
    
    :param: performers Performers
    
    :returns: Self: SpanComponentManager
    */
    func setPerformers(performers: [Performer]) -> SpanComponentManager {
        self.performers = performers
        return self
    }
    
    /**
    Populate Graphs with appropriate SpanComponents from BGLeaves
    
    :returns: Self: SpanComponentManager
    */
    func populateGraphs() -> SpanComponentManager {
        for bgStratum in bgStrata {
            for beamGroup in bgStratum.beamGroups {
                for bgLeaf in beamGroup.leaves {
                    let x: CGFloat = bgStratum.left + beamGroup.left + bgLeaf.xInBeamGroup
                    for component in bgLeaf.spanLeaf!.components {
                        
                        // for testing only
                        let pID = "FL"
                        let iID = "FL"
                        // ----------------
                        
                        // encapsulate to: getPerformerIDandInstrumentIDFromComponent() -> (_,_)
                        switch component {
                        case .Pitch(let pID, let iID, let pitches): break
                        case .Dynamic(let pID, let iID, let marking): break
                        case .Articulation(let pID, let iID, let marking): break
                        case .SlurEnd(let pID, let iID): break
                        case .SlurStart(let pID, let iID): break
                        default: break
                        }
                        
                        for performer in performers {
                            if performer.id == pID {
                                for instrument in performer.instruments {
                                    if instrument.id == iID {
                                        instrumentMatch(
                                            bgLeaf: bgLeaf,
                                            component: component,
                                            instrument: instrument,
                                            x: x
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return self
    }
    
    /**
    Find instr match TEMPORARY DOCUMENTATION
    
    :param: bgLeaf     bgleaf
    :param: component  component
    :param: instrument instr
    :param: x          x
    */
    func instrumentMatch(
        #bgLeaf: BGLeaf,
        component: SpanComponent,
        instrument: Instrument,
        x: CGFloat
    ) {
        // for testing only!
        let staff: Staff = instrument.graphs[0] as Staff

        switch component {
        case .Rest(_, _):
            println("SpanComponentManager: .Rest")
            staff.startNewEventAt(x, bgLeaf: bgLeaf)
            staff.stopLinesAt(x: x)
            bgLeaf.addGraphEvent(staff.getCurrentEvent())
            break
        case .Pitch(_, _, let pitches):
            staff.startNewEventAt(x, bgLeaf: bgLeaf)
            switch bgLeaf.isRest {
            case true: // rest
                staff.stopLinesAt(x: x)
                bgLeaf.addGraphEvent(staff.getCurrentEvent())
            default: // event
                staff.addPitchesToCurrentEvent(pitches: pitches)
                bgLeaf.addGraphEvent(staff.getCurrentEvent())
                if previousBGLeafIsRest(currentBGLeaf: bgLeaf) { staff.startLinesAt(x: x) }
            }
        case .Articulation(_, _, let marking):
            let articulation: Articulation = CreateArticulation().withID(marking)!
            staff.addArticulationToCurrentEvent(articulation: articulation)
        case .SlurStart:
            staff.startSlurAtCurrentEvent()
        case .SlurEnd:
            staff.endSlurAtCurrentEvent()
        default: break
        }
    }
    
    func previousBGLeafIsRest(#currentBGLeaf: BGLeaf) -> Bool {
        var bgLeaves = currentBGLeaf.bgContainer!.beamGroup!.leaves
        var index: Int? = getIndexOfCurrentBGLeaf(currentBGLeaf)
        return index == nil || index == 0 ? false : bgLeaves[index! - 1].isRest
    }
    
    func getIndexOfCurrentBGLeaf(currentBGLeaf: BGLeaf) -> Int? {
        var index: Int?
        var bgLeaves = currentBGLeaf.bgContainer!.beamGroup!.leaves
        for bgl in 0..<bgLeaves.count { if currentBGLeaf === bgLeaves[bgl] { index = bgl } }
        return index
    }
}













