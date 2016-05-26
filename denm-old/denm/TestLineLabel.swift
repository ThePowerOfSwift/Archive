import UIKit
import QuartzCore

class TestLineLabel {
    
    // Info
    var positionValue: CGFloat = 0
    var string: String = ""
    
    // Size
    var height: CGFloat = 0
    var fontName: String = "AvenirNext-Italic"
    
    // Position
    var x: CGFloat = 0
    var top: CGFloat = 0
    var alignment: String = "center"
    var color: CGColor = UIColor.darkGrayColor().CGColor
    
    // things that are shared between labels
    init(height: CGFloat, top: CGFloat, alignment: String, color: CGColor) {
        self.height = height
        self.top = top
        self.alignment = alignment
        self.color = color
    }
    
    // things that change from label to label
    func setStringWithPosition(positionValue: CGFloat, x: CGFloat) -> TestLineLabel {
        self.positionValue = positionValue
        setStringWithPositionValue()
        self.x = x
        return self
    }
    
    func setStringWithString(string: String, x: CGFloat) -> TestLineLabel {
        self.string = string
        self.x = x
        return self
    }

    func build() -> TextLayerByHeight {
        println("build TestLineLabel: string: \(string)")
        let label: TextLayerByHeight = TextLayerByHeight()
            .setInfo(string)
            .setSize(height, fontName: fontName, alignmentMode: alignment)
            .setPosition(x, top: top)
        label.foregroundColor = color
        return label
    }
    
    func setStringWithPositionValue() {
        string =  Double(positionValue).format(".2")
    }
}