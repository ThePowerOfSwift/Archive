import UIKit
import QuartzCore

class TextLayerByHeight: CATextLayer, HeightForLayout {
    
    // size
    var fontName: NSString = ""
    
    // desired height
    var height: CGFloat = 0
    
    // frame dimensions
    var frameLeft: CGFloat = 0
    var frameTop: CGFloat = 0
    var frameWidth: CGFloat = 0
    var frameHeight: CGFloat = 0
    var widthForLayout: CGFloat = 0
    
    // position
    var x: CGFloat = 0
    var top: CGFloat = 0
    
    // init
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setColor(UIColor.blackColor().CGColor)
    }
    override init(layer: AnyObject!) {
        super.init(layer: layer)
        setColor(UIColor.blackColor().CGColor)
    }
    override init() {
        super.init()
        setColor(UIColor.blackColor().CGColor)
    }
    
    func setInfo(string: AnyObject!) -> TextLayerByHeight {
        self.string = string!
        return self
    }
    
    func setSize(height: CGFloat, fontName: NSString!, alignmentMode: String!)
        -> TextLayerByHeight
    {
        self.height = height
        self.fontName = fontName
        self.alignmentMode = alignmentMode
        setFontSize()
        setFont()
        widthForLayout = string.sizeWithAttributes([NSFontAttributeName: font]).width
        contentsScale = UIScreen().scale
        return self
    }
    
    func setPosition(x: CGFloat, top: CGFloat) -> TextLayerByHeight {
        self.x = x; self.top = top
        setFrame()
        return self
    }
    
    func setX(x: CGFloat) -> TextLayerByHeight {
        self.x = x
        setFrame()
        return self
    }
    
    func setTop(top: CGFloat) -> TextLayerByHeight {
        self.top = top
        setFrame()
        return self
    }
    
    func setColor(color: CGColor) -> TextLayerByHeight {
        foregroundColor = color
        return self
    }
    
    private func setFontSize() {
        var scale: CGFloat = (
            UIFont(name: fontName, size: 24)!.capHeight -
                UIFont(name: fontName, size: 12)!.capHeight
            ) / 12.0
        fontSize = height / scale
    }
    
    private func setFont() {
        font = UIFont(name: fontName, size: fontSize)
    }
    
    private func setFrame() {
        setFrameHeight()
        setFrameWidth()
        setFrameLeft()
        setFrameTop()
        frame = CGRectMake(frameLeft, frameTop, frameWidth, frameHeight)
    }
    
    private func setFrameHeight() {
        frameHeight = 1.25 * font.ascender
    }
    
    private func setFrameTop() {
        frameTop = top + (font.capHeight - font.ascender)
    }
    
    private func setFrameWidth() {
        frameWidth = string.sizeWithAttributes([NSFontAttributeName: font]).width
    }
    
    private func setFrameLeft() {
        if alignmentMode == "center" { frameLeft = x - 0.5 * frameWidth}
        if alignmentMode == "left" { frameLeft = x }
        if alignmentMode == "right" { frameLeft = x - frameWidth }
    }
}