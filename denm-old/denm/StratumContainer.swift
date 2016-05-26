import QuartzCore
import UIKit

/**
StratumContainer
*/
class StratumContainer: Stratum {
    
    // MARK: Components
    
    /// Strata contained by StratumContainer
    var strata: [Stratum] = []
    
    var stacksFromBottom: Bool = false

    /**
    Add Stratum to StratumContainer
    
    :param: stratum Stratum
    
    :returns: self: StratumContainer
    */
    func addStratum(stratum: Stratum) -> StratumContainer {
        strata.append(stratum)
        stratum.setContainer(self)
        return self
    }
    
    /**
    Remove Stratum from StratumContainer
    
    :param: stratum Stratum
    
    :returns: Self: StratumContainer
    */
    func removeStratum(stratum: Stratum) -> StratumContainer {
        strata.removeObject(stratum)
        stratum.removeFromSuperlayer()
        positionStrata()
        return self
    }
    
    /**
    Insert Stratum into StratumContainer before Stratum
    
    :param: stratum       Stratum
    :param: beforeStratum Stratum
    */
    func insertStratum(stratum: Stratum, beforeStratum: Stratum) {
        let index: Int = getIndexOfStratum(beforeStratum)!
        strata.insert(stratum, atIndex: index)
        positionStrata()
    }
    
    /**
    Insert Stratum into StratumContainer after Stratum
    
    :param: stratum       Stratum
    :param: beforeStratum Stratum
    */
    func insertStratum(stratum: Stratum, afterStratum: Stratum) {
        let index: Int = getIndexOfStratum(afterStratum)!
        strata.insert(stratum, atIndex: index + 1)
        positionStrata()
    }
    
    
    func setStacksFromBottom(stacksFromBottom: Bool) -> StratumContainer {
        self.stacksFromBottom = stacksFromBottom
        return self
    }
    
    /**
    Stacks Strata graphically based on order
    */
    func positionStrata() {
        var accumTop: CGFloat = 0
        for stratum in strata {
            setStratumLeft(stratum)
            accumulateTopPad(&accumTop, stratum: stratum)
            repositionStratum(accumTop, stratum: stratum)
            accumulateHeight(&accumTop, stratum: stratum)
            accumulateBottomPad(&accumTop, stratum: stratum)
        }
        height = accumTop
        setFrame()
        if container != nil { container!.positionStrata() }
    }
    
    func build() -> StratumContainer {
        commitStrata()
        positionStrata()
        return self
    }
    
    func commitStrata() {
        for stratum in strata { addSublayer(stratum) }
    }
    
    func accumulateTopPad(inout accumTop: CGFloat, stratum: Stratum) {
        if stratum !== strata[0] { accumTop += stratum.externalPads.getTop() }
    }
    
    func accumulateHeight(inout accumTop: CGFloat, stratum: Stratum) {
        accumTop += stratum.frame.height
    }
    
    func accumulateBottomPad(inout accumTop: CGFloat, stratum: Stratum) {
        if stratum !== strata.last! { accumTop += stratum.externalPads.getBottom() }
    }
    
    func repositionStratum(accumTop: CGFloat, stratum: Stratum) {
        stratum.moveTo(x: 0, y: accumTop)
    }
    
    func setStratumLeft(stratum: Stratum) {
        if stratum.left == 0 {
            stratum.position.x = stratum.externalPads.getLeft() + 0.5 * stratum.frame.width
        }
    }
    
    private func getIndexOfStratum(stratum: Stratum) -> Int? {
        for (index, s) in enumerate(strata) { if s === stratum { return index } }; return nil
    }
    
    override func setFrame() {
        frame = CGRectMake(left, top, width, height)
        setExternalPads()
    }
}