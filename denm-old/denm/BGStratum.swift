import UIKit
import QuartzCore

/**
BGStratum (Beam Group Stratum) is collection of references to BeamGroups aligned horizontally
*/
class BGStratum: Stratum {
    
    // MARK: Attributes
    
    /// Duration that BGStratum is offset from beginning of piece: this will become more sophisicated
    var offsetDuration: Duration = Duration()
    
    // MARK: Model Context
    
    /// The System containing BGStratum
    var system: System?
    
    /// Collection of references to BeamGroups in BGStratum
    var beamGroups: [BeamGroup] = []
   
    // MARK: Size
    
    /// Graphical height of a single Guidonian staff space
    var g: CGFloat = 0
    
    /// Graphical width of a single 8th-note
    var beatWidth: CGFloat = 0
    
    // MARK: Position
    
    /**
    Orientation of BeamGroup
    
    - +1: Stems-down
    - -1: Stems-up
    - +0: Neutral
    */
    var o: CGFloat = 1 // Orientation: 1: stems-down, 0: neutral, -1: stems-up
    
    // MARK: Sublayers
    
    // DECompoundStratum
    
    /// Contains references to all TupletBrackets at specified depth
    var tbCompoundStratumAtDepth = Dictionary<Int, TBCompoundStratum>()
    
    /// Contains references to all MGGroups (Metronome Graphic Groups) at specified depth
    var mgCompoundStratumAtDepth = Dictionary<Int, MGCompoundStratum>()
    
    var beamGroupCount: Int = 0
    
    
    // MARK: Incrementally build a BGStratum
    
    /**
    Set system containing BGStratum
    
    :param: system System
    
    :returns: Self: BGStratum
    */
    func setSystem(system: System) -> BGStratum {
        self.system = system
        return self
    }
    
    /**
    Set size of BGStratum
    
    :param: g         Graphical height of a single Guidonian staff space
    :param: beatWidth Graphical width of a single 8th-note
    
    :returns: Self: BGStratum
    */
    func setSize(#g: CGFloat, beatWidth: CGFloat) -> BGStratum {
        self.g = g
        self.beatWidth = beatWidth
        return self
    }
    
    /**
    Set graphical left of BGStratum
    
    :param: left Graphical left of BGStratum
    
    :returns: Self: BGStratum
    */
    func setLeft(left: CGFloat) -> BGStratum {
        self.left = left
        return self
    }
    
    /**
    Set orientation of BGStratum
    
    :param: orientation Orientation of BGStratum
    
    :returns: Self: BGStratum
    */
    func setOrientation(orientation: CGFloat) -> BGStratum {
        self.o = orientation
        return self
    }
    
    func addBeamGroup(beamGroup: BeamGroup) -> BGStratum {
        let dur: Duration = beamGroup.spanTree!.offsetDuration
        let last: BeamGroup? = beamGroups.last
        let newLeft: CGFloat = beamGroups.count > 0 ? last!.left + last!.width : 0
        beamGroup.setBGStratum(self)
            .setSystem(system!)
            .setSize(g: g, beatWidth: beatWidth)
            .setOrientation(o)
            .setLeft(newLeft)
        beamGroups.append(beamGroup)
        return self
    }
    
    func includeTBCompoundStratumAtDepth(depth: Int) -> BGStratum {
        for beamGroup in beamGroups { beamGroup.includeTBStratumAtDepth(depth) }
        return self
    }
    
    func excludeTBCompoundStratumAtDepth(depth: Int) -> BGStratum {
        for beamGroup in beamGroups { beamGroup.excludeTBStratumAtDepth(depth) }
        return self
    }
    
    func includeMGCompoundStratumAtDepth(depth: Int) -> BGStratum {
        for beamGroup in beamGroups { beamGroup.includeMGStratumAtDepth(depth) }
        container!.positionStrata()
        return self
    }
    
    func excludeMGCompoundStratumAtDepth(depth: Int) -> BGStratum {
        for beamGroup in beamGroups { beamGroup.excludeMGStratumAtDepth(depth) }
        container!.positionStrata()
        return self
    }
    
    func build() -> BGStratum {
        setFrame()
        commitBeamGroups()
        createTBCompoundStratumAtDepth()
        createMGCompoundStratumAtDepth()
        normalizeBeamsLayerDisplacement()
        return self
    }
    
    // MARK: User Interface
    
    func play() {
        for beamGroup in beamGroups {
            
            // clean up! make relative!
            let offset: Double = beamGroup.spanTree!.offsetDuration.getTemporalLength(1) - system!.offsetDuration.getTemporalLength(1)
            var timer: NSTimer = NSTimer()
            timer = NSTimer.scheduledTimerWithTimeInterval(offset,
                target: self,
                selector: Selector("highlightNextBeamGroup"),
                userInfo: nil,
                repeats: false
            )
        }
    }
    
    func highlightNextBeamGroup() {
        if beamGroupCount >= beamGroups.count { beamGroupCount = 0 }
        beamGroups[beamGroupCount].highlightMGGroups()
        beamGroupCount++
    }
    
    func createTBCompoundStratumAtDepth() {
        for beamGroup in beamGroups {
            for depth in 0...beamGroup.getGreatestTupletBracketDepth() {
                ensureTBCompoundStratumAtDepth(depth)
                tbCompoundStratumAtDepth[depth]?.addTBStratum(
                    beamGroup.tbStratumAtDepth[depth]!
                )
            }
        }
    }
    
    func ensureTBCompoundStratumAtDepth(depth: Int) {
        if tbCompoundStratumAtDepth[depth] == nil {
            tbCompoundStratumAtDepth[depth] = TBCompoundStratum()!
        }
    }
    
    func createMGCompoundStratumAtDepth() {
        for beamGroup in beamGroups {
            for depth in 0...beamGroup.getGreatestTupletBracketDepth() {
                ensureMGCompoundStratumAtDepth(depth)
                mgCompoundStratumAtDepth[depth]?.addMGStratum(
                    beamGroup.mgStratumAtDepth[depth]!
                )
                mgCompoundStratumAtDepth[depth]?.build()
            }
        }
    }
    
    func ensureMGCompoundStratumAtDepth(depth: Int) {
        if mgCompoundStratumAtDepth[depth] == nil {
            mgCompoundStratumAtDepth[depth] = MGCompoundStratum()!
        }
    }
    
    func normalizeBeamsLayerDisplacement() {
        let beamsLayerDisplaceY: CGFloat = getBeamsLayerDisplaceY()
        for beamGroup in beamGroups {
            beamGroup.beamsLayerStratum.moveTo(x: 0, y: beamsLayerDisplaceY)
        }
    }
    
    func getBeamsLayerDisplaceY() -> CGFloat {
        var displaceY: CGFloat = 0
        for beamGroup in beamGroups {
            if beamGroup.getGreatestTupletBracketDepth() == getGreatestBeamGroupDepth() {
                displaceY = beamGroup.containers[0].beams.frame.minY
            }
        }
        return displaceY
    }
    
    func getBeamsLayerStratumMinYAtGreatestDepth() -> CGFloat {
        var beamsLayerStratumMinY: CGFloat = 0
        for beamGroup in beamGroups {
            if beamGroup.getGreatestTupletBracketDepth() == getGreatestBeamGroupDepth() {
                beamsLayerStratumMinY = beamGroup.beamsLayerStratum.frame.minY
                break
            }
        }
        return beamsLayerStratumMinY
    }
    
    override func setFrame() {
        setExternalPads()
        width = 1000 // for testing only, perhaps not necessary at all
        height = getGreatestBeamGroupHeight()
        frame = CGRectMake(left, top, width, height)
    }
    
    override func setExternalPads() {
        //externalPads.setBottom(10)
    }
    
    func commitBeamGroups() {
        for beamGroup in beamGroups {
            addSublayer(beamGroup)
        }
    }
    
    func getGreatestBeamGroupHeight() -> CGFloat {
        var maxHeight: CGFloat = 0
        for beamGroup in beamGroups {
            maxHeight = beamGroup.height > maxHeight ? beamGroup.height : maxHeight
        }
        return maxHeight
    }
    
    func getGreatestBeamGroupDepth() -> Int {
        var maxDepth: Int = 0
        for beamGroup in beamGroups {
            let greatestDepth: Int = beamGroup.getGreatestTupletBracketDepth()
            maxDepth = greatestDepth > maxDepth ? greatestDepth : maxDepth
        }
        return maxDepth
    }
}