import QuartzCore
import UIKit

/**
MGSubgroup (MetronomeGraphic Subgroup): collection of MetronomeGraphics connected by ligature

Is built upon MetronomeSpanNode (situated inside MGGroup, which is built upon MetronomeSpanTree)
*/
class MGSubgroup: Stratum {
    
    // MARK: View Context
    
    /// MGGroup (Metronome Graphic Group) container MGSubgroup
    var mgGroup: MGGroup?
    
    var metronomeGraphics: [MetronomeGraphic] = []
    
    // MARK: Model Context
    
    /// MetronomeSpanNode of MGSubgroup
    var metronomeSpanNode: MetronomeSpanNode?
    
    // MARK: Size
    
    /// Graphical height of a single Guidonian staff space
    var g: CGFloat = 0
    
    /// Graphical width of a single 8th-note
    var beatWidth: CGFloat = 0
    
    // MARK: Attributes
    
    /// Levels embedded in MetronomeSpanTree (different 'depth's for SpanTree and MetronomeSpanTree)
    var depth: Int = 0
    
    /// If MGSubgroup is included in View Context
    var isIncluded: Bool = true
    
    // MARK: Components
    
    /// MGLigature (Metronome Graphic Ligature) of MGSubgroup
    var ligature: MGLigature?
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) {super.init(coder: aDecoder) }
    override init(layer: AnyObject) { super.init(layer: layer) }
    override init() { super.init() }
    
    func setMetronomeSpanNode(metronomeSpanNode: MetronomeSpanNode) -> MGSubgroup {
        self.metronomeSpanNode = metronomeSpanNode
        return self
    }
    
    func setMGGroup(mgGroup: MGGroup) -> MGSubgroup {
        self.mgGroup = mgGroup
        return self
    }
    
    func setSize(#g: CGFloat) -> MGSubgroup {
        self.g = g
        return self
    }
    
    func setBeatWidth(beatWidth: CGFloat) -> MGSubgroup {
        self.beatWidth = beatWidth
        return self
    }
    
    func setDepth(depth: Int) -> MGSubgroup {
        self.depth = depth
        return self
    }
    
    func setIsIncluded(isIncluded: Bool) -> MGSubgroup {
        self.isIncluded = isIncluded
        return self
    }
    
    
    
    override func setFrame() {
        // see MGGroup
    }
    
    func highlightAtTempo(metronomeMarking: Float) {
        
    }
}