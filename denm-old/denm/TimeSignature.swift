import UIKit
import QuartzCore

/**
Adjust to be stratumContainer
*/
class TimeSignature: StratumObject {
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }

    // MARK: View Context
    
    var tsStratum: TimeSignatureStratum?
    
    var measure: Measure?
    
    // Info ===================================================================================
    var numerator: Int = 0
    var denominator: Int = 0
    
    // Size ===================================================================================
    var height: CGFloat = 0
    var width: CGFloat = 0
    var pad: CGFloat = 0
    
    // Position ===============================================================================
    var center: CGFloat = 0
    var left: CGFloat = 0
    var top: CGFloat = 0
    
    // Components =============================================================================
    var components: [HeightForLayout] = []
    var padVertical: PadVertical = PadVertical(height: 0)
    var numeratorLayer: TextLayerByHeight = TextLayerByHeight()
    var denominatorLayer: TextLayerByHeight = TextLayerByHeight()
    
    // Visual =================================================================================
    var fontName: String = "Baskerville-SemiBold"
    var color: CGColor = UIColor.brownColor().CGColor
    
    func setTSStratum(tsStratum: TimeSignatureStratum) -> TimeSignature {
        self.tsStratum = tsStratum
        return self
    }
    
    func setMeasure(measure: Measure) -> TimeSignature {
        self.measure = measure
        return self
    }
    
    func setNumerator(numerator: Int, denominator: Int) -> TimeSignature {
        self.numerator = numerator
        self.denominator = denominator
        return self
    }
    
    func setSize(height: CGFloat) -> TimeSignature {
        self.height = height
        padVertical.setHeight(0.0618 * height)
        return self
    }
    
    func setPosition(center: CGFloat, top: CGFloat) -> TimeSignature {
        self.center = center
        self.top = top
        return self
    }
    
    func setCenter(center: CGFloat) -> TimeSignature {
        self.center = center
        return self
    }
    
    func setTop(top: CGFloat) -> TimeSignature {
        self.top = top
        return self
    }
    
    func setColor(color: CGColor) -> TimeSignature {
        self.color = color
        return self
    }
    
    func addComponents() -> TimeSignature {
        let textLayers = createTextLayers()
        setWidthToMaxWidthOf(textLayers)
        setTextLayersX(textLayers)
        components = [numeratorLayer, padVertical, denominatorLayer]
        return self
    }
    
    func addPadVertical() -> TimeSignature {
        return self
    }
    
    func setWidth() -> TimeSignature {
        
        return self
    }
    
    override func setFrame() {
        frame = CGRectMake(center - 0.5 * width, top, width, height)
    }
    
    func build() -> TimeSignature {
        addComponents()
        setComponentsTop()
        setFrame()
        //encapsulate
        for component in components {
            if let textLayer = component as? TextLayerByHeight { addSublayer(textLayer) }
        }
        return self
    }
    
    func createTextLayers() -> [TextLayerByHeight] {
        
        let numbers: [Int] = [numerator, denominator]
        let textLayers = [numeratorLayer, denominatorLayer]
        let textHeight: CGFloat = (height / 2) - (padVertical.frame.height / 2)
        
        // Set string and size of both textLayers
        for n in 0..<textLayers.count {
            textLayers[n]
                .setInfo("\(numbers[n])")
                .setSize(textHeight, fontName: fontName, alignmentMode: "center")
                .setColor(color)
        }
        return textLayers
    }
    
    func setComponentsTop() -> TimeSignature {
        var accumTop: CGFloat = 0
        for component in components {
            if let textLayer = component as? TextLayerByHeight {
                textLayer.setTop(accumTop)
                accumTop += textLayer.height
            }
            else { accumTop += component.frame.height }
        }
        return self
    }
    
    func setTextLayersX(textLayers: [TextLayerByHeight]) {
        for layer in textLayers { layer.setX(0.5 * width) }
    }
    
    func setWidthToMaxWidthOf(textLayers: [TextLayerByHeight]) {
        width = getMaxWidth(textLayers)
    }
    
    func getMaxWidth(textLayers: [TextLayerByHeight]) -> CGFloat {
        var maxWidth: CGFloat = 0
        for layer in textLayers {
            maxWidth = layer.widthForLayout > maxWidth ? layer.widthForLayout : maxWidth
        }
        return maxWidth
    }
    
    override func hitTest(p: CGPoint) -> CALayer! {
        if containsPoint(p) { return self }
        else { return nil }
    }
    
    override func containsPoint(p: CGPoint) -> Bool {
        return CGRectContainsPoint(frame, p)
    }
}