import UIKit
import QuartzCore

class MeasureNumber: StratumObject {
    
    // Info ===================================================================================
    var number: Int = 0
    
    // Size ===================================================================================
    var height: CGFloat = 0
    var width: CGFloat = 0
    var pad: CGFloat = 0
    
    // Position ===============================================================================
    var center: CGFloat = 0
    var left: CGFloat = 0
    var top: CGFloat = 0
    
    // Components =============================================================================
    var textLayer: TextLayerByHeight = TextLayerByHeight()
    
    // Visual  ================================================================================
    var color: CGColor = UIColor.grayColor().CGColor
    
    var measure: Measure?
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init() { super.init() }
    override init(layer: AnyObject) { super.init(layer: layer) }
    
    func setMeasure(measure: Measure) -> MeasureNumber {
        self.measure = measure
        return self
    }
    
    func setNumber(number: Int) -> MeasureNumber {
        self.number = number
        textLayer.string = "\(number)"
        return self
    }
    
    func setSize(height: CGFloat) -> MeasureNumber {
        self.height = height
        self.pad = 0.2 * height
        let textHeight = height - 2 * pad
        textLayer.setSize(textHeight, fontName: "AvenirNext-Medium", alignmentMode: "center")
        return self
    }
    
    func setCenter(center: CGFloat) -> MeasureNumber {
        self.center = center
        setFrame()
        return self
    }
    
    func setTop(top: CGFloat) -> MeasureNumber {
        self.top = top
        setFrame()
        return self
    }
    
    func setPosition(center: CGFloat, top: CGFloat) -> MeasureNumber {
        self.center = center
        self.top = top
        self.left = center - (textLayer.widthForLayout + pad)
        self.width = textLayer.widthForLayout + 2 * pad
        textLayer.setPosition(0.5 * width, top: pad)
        setFrame()
        return self
    }
    
    func build() -> MeasureNumber {
        setFrame()
        setVisualAttributes()
        addSublayer(textLayer)
        return self
    }
    
    func setVisualAttributes() {
        setColor(color)
        borderWidth = 1
        textLayer.setPosition(0.5 * width, top: pad)
    }
    
    func setColor(color: CGColor) {
        self.color = color
        textLayer.foregroundColor = color
        borderColor = UIColor.lightGrayColor().CGColor
    }
    
    override func setFrame() {
        width = textLayer.widthForLayout + 2 * pad
        frame = CGRectMake(center - 0.5 * width, top, width, height)
    }
    
    override func hitTest(p: CGPoint) -> CALayer! {
        if containsPoint(p) { return self }
        else { return nil }
    }
    
    override func containsPoint(p: CGPoint) -> Bool {
        return CGRectContainsPoint(frame, p)
    }
}