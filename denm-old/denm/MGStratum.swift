import QuartzCore
import UIKit

/**
MGStratum (Metronome Graphic Stratum)
*/
class MGStratum: Stratum {
    
    // MARK: View Context
    
    /// BeamGroup that contains MGStratum
    var beamGroup: BeamGroup?
    
    /// MGGroups (Metronome Graphic Group) contained in MGStratum
    var mgGroups: [MGGroup] = []
    
    // MARK: Attributes
    
    /// If MGStratum is included in View Context
    var isIncluded: Bool = false
    
    /// Levels embedded in tuplet
    var depth: Int = 0
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build a MGStratum
    
    /**
    Set BeamGroup
    
    :param: beamGroup BeamGroup
    
    :returns: MGStratum
    */
    func setBeamGroup(beamGroup: BeamGroup) -> MGStratum {
        self.beamGroup = beamGroup
        return self
    }
    
    /**
    Set top of MGStratum
    
    :param: top Top of MGStratum
    
    :returns: Self: MGStratum
    */
    func setTop(top: CGFloat) -> MGStratum {
        self.top = top
        return self
    }
    
    /**
    Set height of MGStratum
    
    :param: height Height of MGStratum
    
    :returns: Self: MGStratum
    */
    func setHeight(height: CGFloat) -> MGStratum {
        self.height = height
        setFrame()
        setHeightOfMGGroupsToMaxHeight()
        return self
    }
    
    /**
    Set depth of MGStratum
    
    :param: depth Levels embedded in tuplet
    
    :returns: Self: MGStratum
    */
    func setDepth(depth: Int) -> MGStratum {
        self.depth = depth
        return self
    }
    
    /**
    Set if MGStratum is included in View Context
    
    :param: isIncluded If MGStratum is included in View Context
    
    :returns: Self: MGStratum
    */
    func setIsIncluded(isIncluded: Bool) -> MGStratum {
        self.isIncluded = isIncluded
        return self
    }
    
    /**
    Add MGGroup to MGStratum
    
    :param: mgGroup MGGroup (Metronome Graphic Group)
    
    :returns: Self: MGStratum
    */
    func addMGGroup(mgGroup: MGGroup) -> MGStratum {
        mgGroup.setMGStratum(self)
        mgGroups.append(mgGroup)
        return self
    }
    
    /**
    Set dimensions of MGStratum
    
    :returns: Self: MGStratum
    */
    func build() -> MGStratum {
        setWidth()
        setHeight()
        setExternalPads()
        setFrame()
        return self
    }

    /**
    Overrides Stratum.moveTo(x:y:)
    
    :param: x x-value
    :param: y y-value
    */
    override func moveTo(#x: CGFloat, y: CGFloat) {
        for mgGroup in mgGroups {
            if mgGroup.superlayer == nil { CATransaction.setDisableActions(true) }
            mgGroup.position.y = y + 0.5 * mgGroup.frame.height
            CATransaction.setDisableActions(false)
        }
    }
    
    // MARK: User Interface
    
    /**
    Highlight MGStratum
    */
    func highlight() {
        for mgGroup in mgGroups {
            CATransaction.setDisableActions(true)
            mgGroup.highlight()
            CATransaction.setDisableActions(false)
        }
    }
    
    internal func include() {
        if !isIncluded {
            let tbStratum: TBStratum = beamGroup!.tbStratumAtDepth[depth]!
            beamGroup!.insertStratum(self, afterStratum: tbStratum)
            repositionBGStratum()

            CATransaction.setDisableActions(true)
            for mgGroup in mgGroups {
                mgGroup.beginTime = CACurrentMediaTime() + 0.075
                mgGroup.bgContainer!.addSublayer(mgGroup)
            }
            CATransaction.setDisableActions(false)
            
            isIncluded = true
        }
    }
    
    internal func exclude() {
        if isIncluded {
            
            CATransaction.setDisableActions(true)
            for mgGroup in mgGroups { mgGroup.removeFromSuperlayer() }
            CATransaction.setDisableActions(false)
            
            beamGroup!.removeStratum(self)
            repositionBGStratum()
            isIncluded = false
        }
    }
    
    internal func repositionBGStratum() {
        beamGroup!.bgStratum!.normalizeBeamsLayerDisplacement()
        beamGroup!.bgStratum!.setFrame()
        beamGroup!.bgStratum!.system!.positionStrata()
    }
    
    internal func getGreatestMGGroupHeight() -> CGFloat {
        var maxHeight: CGFloat = 0
        for mgGroup in mgGroups {
            maxHeight = mgGroup.frame.height > maxHeight ? mgGroup.frame.height : maxHeight
        }
        return maxHeight
    }
    
    internal func setHeight() {
        height = getGreatestMGGroupHeight()
        setHeightOfMGGroupsToMaxHeight()
    }
    
    internal func setHeightOfMGGroupsToMaxHeight() {
        setFrame()
        for mgGroup in mgGroups { mgGroup.setHeight(height).setFrame() }
    }
    
    internal override func setWidth() -> MGStratum {
        width = getGreatestMGGroupWidth()
        return self
    }
    
    internal func getGreatestMGGroupWidth() -> CGFloat {
        var maxWidth: CGFloat = 0
        for mgGroup in mgGroups {
            maxWidth = mgGroup.frame.maxX > maxWidth ? mgGroup.frame.maxX : maxWidth
        }
        return maxWidth
    }

    override func setExternalPads() {
        externalPads.setBottom(5) // make this relative, but not wishywashy?
        
        //externalPads.setTop(0.1618 * height)
        //externalPads.setBottom(0.382 * height)
    }
}