import UIKit
import QuartzCore

/**
Dynamic Marking Stratum: Contains all Dynamic Markings and Interpolations
*/
class DMStratum: Stratum {
    
    // MARK: Components
    
    /// Collection of DynamicMarkings
    var dynamicMarkings: [DynamicMarking] = []
    
    /// Collection of DMInterpolations (Dynamic Marking Interpolations)
    var dmInterpolations: [DMInterpolation] = []
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build a DMStratum
    
    /**
    Set top of DMStratum
    
    :param: top Top of DMStratum
    
    :returns: Self: DMStratum
    */
    func setTop(top: CGFloat) -> DMStratum {
        self.top = top
        return self
    }
    
    /**
    Set height of DMStratum
    
    :param: height Height of DMStratum
    
    :returns: Self: DMStratum
    */
    func setHeight(height: CGFloat) -> DMStratum {
        self.height = height
        return self
    }
    
    /**
    Add DynamicMarking at x-value
    
    :param: dynamicMarking DynamicMarking
    :param: x              x-value
    
    :returns: Self: DMStratum
    */
    func addDynamicMarking(dynamicMarking: DynamicMarking, x: CGFloat) -> DMStratum {
        dynamicMarking
            .setX(x)
            .setHeight(height)
            .build()
        completeLastInterpolationWithDynamicMarking(dynamicMarking)
        dynamicMarkings.append(dynamicMarking)
        return self
    }
    
    
    
    /**
    Add DMInterpolation (Dynamic Marking Interpolation)
    
    :param: type Type of DMInterpolation
    
    :returns: Self: DMStratum
    */
    func addDMInterpolation(type: String) -> DMStratum {
        //let dmInterpolation: DMInterpolation = CreateDMInterpolation().withID(type)!
        
        let dmInterpolation: DMInterpolation = DMIStatic()
        let kerning: CGFloat = getInterpolationKerningLeft(dmInterpolation)
        let x: CGFloat = dynamicMarkings.last!.frame.maxX + kerning
        setInterpolationDimensions(dmInterpolation)
        dmInterpolations.append(dmInterpolation)
        return self
    }
    
    /**
    Add DMInterpolation (Dynamic Marking Interpolation) static
    
    :returns: Self: DMStratum
    */
    func addInterpolationStatic() -> DMStratum {
        let dmInterpolation: DMInterpolation = DMIStatic()
        setInterpolationDimensions(dmInterpolation)
        dmInterpolations.append(dmInterpolation)
        return self
    }
    
    /**
    Add DMInterpolation (Dynamic Marking Interpolation) static
    
    :returns: Self: DMStratum
    */
    func addInterpolationHairpin() -> DMStratum {
        
        // check cresc / decresc
        
        var dmInterpolation: DMIHairpinLinear = DMIHairpinLinear()
        setInterpolationDimensions(dmInterpolation)
        dmInterpolations.append(dmInterpolation)
        return self
    }
    
    func addInterpolationHairpin(exponent: CGFloat) -> DMStratum {
        return self
    }
    
    func addInterpolationSwell() -> DMStratum {
        return self
    }
    
    func addInterpolationSwellConcave() -> DMStratum {
        return self
    }
    
    func addInterpolationSwellConcave(exponent: CGFloat) -> DMStratum {
        return self
    }
    
    func addInterpolationSwellConvex() -> DMStratum {
        return self
    }
    
    func addInterpolationSwellConvex(exponent: CGFloat) -> DMStratum {
        return self
    }
    
    func build() -> DMStratum {
        setWidth()
        setFrame()
        commitDynammicMarkings()
        commitDMInterpolations()
        for object in objects { addSublayer(object) }
        return self
    }
    
    func setInterpolationDimensions(dmInterpolation: DMInterpolation) {
        let x = dynamicMarkings.last!.frame.maxX + getInterpolationKerningLeft(dmInterpolation)
        dmInterpolation.setHeight(0.33 * height).setY(0.5 * height).setX0(x)
    }
    
    func commitDynammicMarkings() {
        for dynamicMarking in dynamicMarkings {
            addObject(dynamicMarking)
        }
    }
    
    func commitDMInterpolations() {
        for dmInterpolation in dmInterpolations {
            dmInterpolation.build()
            addObject(dmInterpolation)
        }
    }
    
    func completeLastInterpolationWithDynamicMarking(dynamicMarking: DynamicMarking) {
        if dmInterpolations.count > 0 && dmInterpolations.last!.x1 == nil {
            let kerning: CGFloat = getInterpolationKerningRight(dynamicMarking)
            dmInterpolations.last!.setX1(dynamicMarking.frame.minX + kerning)
        }
        
        // check for cresc / decresc if necessary
        if let hairpin = dmInterpolations.last? as? DMIHairpin {
            hairpin.setDirection(getHairpinDirection(dynamicMarkings.last!, b: dynamicMarking))
        }
    }
    
    func getHairpinDirection(a: DynamicMarking, b: DynamicMarking) -> String {
        // contingency for aEnd == bStart
        var direction: String = ""
        var aEnd: Int = a.values.last!
        var bStart: Int = b.values[0]
        direction = aEnd > bStart ? "decresc" : "cresc"
        return direction
    }
    
    func getInterpolationKerningLeft(dmInterpolation: DMInterpolation) -> CGFloat {
        let dynamicMarking: DynamicMarking = dynamicMarkings.last!
        let pair: [String] = [
            dynamicMarking.characters.last!.kerningKey,
            dmInterpolation.kerningKey
        ]
        for (tablePair, kerning) in DMKerningTable { if pair == tablePair {
            return kerning * dynamicMarking.characters.last!.frame.width
        }}
        return 0.0
    }
    
    func getInterpolationKerningRight(dynamicMarking: DynamicMarking) -> CGFloat {
        let pair: [String] = [
            dmInterpolations.last!.kerningKey,
            dynamicMarking.characters.last!.kerningKey
        ]
        for (tablePair, kerning) in DMKerningTable { if pair == tablePair {
            return kerning * dynamicMarking.characters.last!.frame.width
        }}
        return 0.0
    }
    
    override func setExternalPads() {
        externalPads.setTop(10)
    }
}