import QuartzCore

/**
StaffEvent
*/
class StaffEvent: GraphEvent {
    
    // MARK: Components
    
    /// Staff upon which StaffEvent ocurrs
    var staff: Staff?
    
    /// Pitchs in StaffEvent
    var pitches: [Pitch] = []
    
    /// Array of Dyads in StaffEvent
    var dyadList: [Dyad] = []
    
    /// Least value of staff space with musical info
    var minStaffSpace: CGFloat { get { return getMaxStaffSpace() } }
    
    /// Greatest value of staff space with musical info
    var maxStaffSpace: CGFloat { get { return getMinStaffSpace() } }
    
    // MARK: Incrementally build a StaffEvent
    
    /**
    Set Graph
    
    :param: graph Graph
    
    :returns: Self: StaffEvent
    */
    override func setGraph(graph: Graph) -> StaffEvent {
        self.graph = graph
        return self
    }
    
    /**
    Set BGLeaf (Beam Group Leaf)
    
    :param: bgLeaf BGLeaf
    
    :returns: Self: StaffEvent
    */
    override func setBGLeaf(bgLeaf: BGLeaf) -> StaffEvent {
        self.bgLeaf = bgLeaf
        return self
    }
    
    /**
    Add Pitch
    
    :param: pitch Pitch
    
    :returns: Self: StaffEvent
    */
    func addPitch(pitch: Pitch) -> StaffEvent {
        pitches.append(pitch)
        return self
    }
    
    // clean up in feb
    override func startSlur() {
        startsSlur = true
        
        /*
        var y: CGFloat = getMaxInfoY() - (graph as Staff).staffDisplaceFromTop // make avoid articulations
        let slur: Slur = Slur().setStartPoint(CGPointMake(x, y))
        (graph as Staff).infoLayer.slurs.append(slur) // clean
        */
    }
    
    // clean up in feb
    override func endSlur() {
        endsSlur = true
        
        /*
        var y: CGFloat = getMaxInfoY() - (graph as Staff).staffDisplaceFromTop
        let slur: Slur = (graph as Staff).infoLayer.slurs.last!
        slur.setEndPoint(CGPointMake(x, y)).build() // clean
        */
    }
    
    // MARK: Pitch Spelling
    
    func spellPitches() {
        if pitches.count == 1 { pitches[0].spell() }
        else {
            createDyadList()
            for dyad in dyadList { dyad.spell() }
        }
    }
    
    // MARK: Analysis
    
    /**
    Get y-value of endpoint of Stem
    
    :returns: CGFloat: y-value of endpoint of Stem
    */
    override func getStemInfoEndY() -> CGFloat {
        let beamGroup = bgLeaf!.bgContainer!.beamGroup!
        if beamGroup.o == 1 {
            let beamGroupHeight = beamGroup.frame.height
            let stratumDisplace = staff!.frame.minY - beamGroup.frame.maxY
            return beamGroupHeight + stratumDisplace + maxInfoY
        }
        else {
            let stratumDisplace = beamGroup.frame.minY - staff!.frame.minY
            return -(stratumDisplace + minInfoY)
        }
    }
    
    /**
    Get least value of staff space with musical info
    
    :returns: CGFloat: least value of staff space with musical info
    */
    func getMinStaffSpace() -> CGFloat {
        var minStaffSpace: CGFloat?
        for item in items {
            if let i = item as? StaffSpace {
                if minStaffSpace == nil { minStaffSpace = i.staffSpace }
                else if i.staffSpace < minStaffSpace { minStaffSpace = i.staffSpace }
            }
        }
        return minStaffSpace!
    }
    
    /**
    Get greatest value of staff space with musical info
    
    :returns: CGFloat: greatest value of staff space with musical info
    */
    func getMaxStaffSpace() -> CGFloat {
        var maxStaffSpace: CGFloat?
        for item in items {
            if let i = item as? StaffSpace {
                if maxStaffSpace == nil { maxStaffSpace = i.staffSpace }
                else if i.staffSpace > maxStaffSpace { maxStaffSpace = i.staffSpace }
            }
        }
        return maxStaffSpace!
    }
    
    /**
    Get amount of ledger lines above and below staff in StaffEvent
    
    :returns: Tuple of ledger lines (above, below)
    */
    func getLedgerLines() -> (Int, Int) {
        var maxStaffSpace: CGFloat = 0
        var minStaffSpace: CGFloat = -4
        for item in items {
            if let i = item as? StaffSpace {
                maxStaffSpace = i.staffSpace > maxStaffSpace ? i.staffSpace : maxStaffSpace
                minStaffSpace = i.staffSpace < minStaffSpace ? i.staffSpace : minStaffSpace
            }
        }
        var above: Int = 0
        var below: Int = 0
        if maxStaffSpace >= +1 { above = Int(floor(maxStaffSpace)) }
        if minStaffSpace <= -5 { below = Int(floor(abs(minStaffSpace) - 4)) }
        return (above, below)
    }
    
    // MARK: Create components
    
    /**
    Creates Noteheads and Accidentals for Pitches in StaffEvent
    
    :param: g                 Graphical height of a single Guidonian staff space
    :param: middleCStaffSpace Staff spaces of middleC (MIDI: 60)
    
    :returns: Tuple of Arrays of Noteheads and Accidentals
    */
    func makeNoteheadsAndAccidentals(#g: CGFloat, middleCStaffSpace: CGFloat)
        -> ([Notehead],[Accidental]) {
        let noteheads = makeNoteheads(g: g, middleCStaffSpace: middleCStaffSpace)
        let accidentals = makeAccidentals(g: g, middleCStaffSpace: middleCStaffSpace)
        return (noteheads, accidentals)
    }
    
    func makeArticulations(#g: CGFloat) -> [Articulation] {
        
        // position here -- though not working?
        
        var y: CGFloat = 0
        let noteheadY = getMaxInfoY()
        if (noteheadY / g) % 1 == 0 {
            // something
            y = noteheadY + 1.5 * g
        }
        else {
            // something else
            y = noteheadY + g
        }
        
        for articulation in articulations {
            articulation.setSize(g: g)
                .setX(x)
                .setY(y)
                .build()
        }
        for articulation in articulations { addItem(articulation) }
        return articulations
    }
    
    private func makeNoteheads(#g: CGFloat, middleCStaffSpace: CGFloat) -> [Notehead] {
        var noteheads: [Notehead] = []
        for pitch in pitches {
            let notehead: Notehead = CreateNotehead().withType("ord")!
                .setSize(g: g)
                .setX(x)
                .setYWithStaffSpace(pitch.staffSpacesFromMiddleC + middleCStaffSpace)
                .build()
            noteheads.append(notehead)
        }
        for notehead in noteheads { addItem(notehead) }
        return noteheads
    }
    

    private func makeAccidentals(#g: CGFloat, middleCStaffSpace: CGFloat) -> [Accidental] {
        var accidentals: [Accidental] = []
        for pitch in pitches {
            let coarse = pitch.spelling!.coarse
            let fine = pitch.spelling!.fine
            let accidental: Accidental = CreateAccidental().withCoarse(coarse, fine: fine)!
                .setSize(g: g)
                .setX(x - 1.5 * g)
                .setYWithStaffSpace(pitch.staffSpacesFromMiddleC + middleCStaffSpace)
                .build()
            accidentals.append(accidental)
        }
        for accidental in accidentals { addItem(accidental) }
        return accidentals
    }
    
    private func createDyadList() {
        for p in 0..<pitches.count {
            for pp in p + 1..<pitches.count {
                dyadList.append(Dyad(pitch0: pitches[p], pitch1: pitches[pp]))
            }
        }
        dyadList.sort { $0.complexity < $1.complexity }
    }
    
    override func getMaxInfoY() -> CGFloat {
        if items.count == 0 { return getYFromStaffSpace(0) } // return top of staff
        else {
            var maxInfoY: CGFloat?
            for i in items {
                if let item = i as? StaffSpace {
                    let itemY: CGFloat = getYFromStaffSpace(item.staffSpace)
                    if maxInfoY == nil { maxInfoY = itemY }
                    else { if itemY > maxInfoY { maxInfoY = itemY } }
                }
            }
            return maxInfoY!
        }
    }
    
    override func getMinInfoY() -> CGFloat {
        if items.count == 0 { return getYFromStaffSpace(4) } // return bottom of staff
        else {
            var minInfoY: CGFloat?
            for i in items {
                if let item = i as? StaffSpace {
                    let itemY: CGFloat = getYFromStaffSpace(item.staffSpace)
                    if minInfoY == nil { minInfoY = itemY }
                    else { if itemY < minInfoY { minInfoY = itemY } }
                }
            }
            return minInfoY!
        }
    }
    
    private func getYFromStaffSpace(staffSpace: CGFloat) -> CGFloat {
        let staff = graph! as Staff
        return staff.staffDisplaceFromTop + -staffSpace * staff.g
    }
}