import UIKit

class MetronomeGridRect: CAShapeLayer {
    
    var top: CGFloat = 0
    var left: CGFloat = 0
    var width: CGFloat = 0
    var height: CGFloat = 0
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    /**
    Set top of a MetronomeGridRect
    
    :param: top Top of a MetronomeGridRect
    
    :returns: Self: MetronomeGridRect
    */
    func setTop(top: CGFloat) -> MetronomeGridRect {
        self.top = top
        return self
    }
    
    /**
    Set left of a MetronomeGridRect
    
    :param: left Left of a MetronomeGridRect
    
    :returns: Self: MetronomeGridRect
    */
    func setLeft(left: CGFloat) -> MetronomeGridRect {
        self.left = left
        return self
    }
    
    /**
    Set width of a MetronomeGridRect
    
    :param: width Width of a MetronomeGridRect
    
    :returns: Self: MetronomeGridRect
    */
    func setWidth(width: CGFloat) -> MetronomeGridRect {
        self.width = width
        return self
    }
    
    /**
    Set height of a MetronomeGridRect
    
    :param: height Height of a MetronomeGridRect
    
    :returns: Self: MetronomeGridRect
    */
    func setHeight(height: CGFloat) -> MetronomeGridRect {
        self.height = height
        return self
    }
    
    func build() -> MetronomeGridRect {
        setFrame()
        setVisualAttributes()
        return self
    }
    
    func setVisualAttributes() {
        borderWidth = 1
        borderColor = UIColor.redColor().CGColor
        //backgroundColor = UIColor.lightGrayColor().CGColor
        opacity = 0.1618
    }
    
    func setFrame() -> MetronomeGridRect {
        frame = CGRectMake(left, top, width, height)
        return self
    }
}