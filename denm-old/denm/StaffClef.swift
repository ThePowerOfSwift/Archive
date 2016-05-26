import UIKit
import QuartzCore

/**
StaffClef
*/
class StaffClef: Clef {
    
    // MARK: Attributes
    
    /// Amount of octaves of transposition of StaffClef
    var transposition: Int = 0
    
    /// Location in StaffSpaces from top line of Staff of middleC
    var middleCStaffSpace: CGFloat = 0
    
    // MARK: Visual Attributes
    
    /// Length of transpositionLine: make this local
    var transpositionLineLength: CGFloat = 0
    
    // MARK: Incrementally build a StaffClef
    
    /**
    Set size of StaffClef with Graphical height of a single Guidonian staff space
    
    :param: g Graphical height of a single Guidonian staff space
    
    :returns: Self: Clef
    */
    func setSize(#g: CGFloat) -> Clef {
        self.g = g
        self.height = 4 * g
        self.lineWidth = 0.1 * g
        self.width = 1.236 * g
        return self
    }
    
    /**
    Set transposition of StaffClef
    
    :param: transposition Amount of octaves of transposition of StaffClef
    
    :returns: Self: Clef
    */
    func setTransposition(transposition: Int) -> Clef {
        self.transposition = transposition
        return self
    }
    
    /**
    Add all necessary components to StaffClef layer
    
    :returns: Self: Clef
    */
    override func build() -> Clef {
        setMiddleCStaffSpace()
        adjustMiddleCStaffSpaceWithTransposition()
        setFrame()
        addLine()
        addDecorator()
        addTranspositionLabel()
        return self
    }
    
    internal func addTranspositionLabel() {
        if transposition != 0 {
            addTranspositionText()
            addTranspositionLine()
        }
    }
    
    internal func addTranspositionText() {
        let textHeight: CGFloat = 0.875 * g
        let displace: CGFloat = 0.382 * g
        let top: CGFloat = transposition < 0 ? height + displace : -(displace + textHeight)
        let text: TextLayerByHeight = TextLayerByHeight()
            .setInfo(getTranspositionDisplay())
            .setSize(textHeight,
                fontName: "AvenirNext-Medium",
                alignmentMode: "center"
            )
            .setTop(top)
            .setX(0.5 * width)
            .setColor(color)
        transpositionLineLength = text.frame.width
        addSublayer(text)
    }
    
    internal func addTranspositionLine() {
        // encapsulate
        let y: CGFloat = transposition < 0 ? height : 0
        let length: CGFloat = transpositionLineLength
        let transpositionLine: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        path.moveToPoint(CGPointMake(0.5 * width - 0.5 * length, y))
        path.addLineToPoint(CGPointMake(0.5 * width + 0.5 * length, y))
        transpositionLine.path = path.CGPath
        transpositionLine.lineWidth = lineWidth
        transpositionLine.strokeColor = color
        addSublayer(transpositionLine)
    }
    
    internal func getTranspositionDisplay() -> String {
        let getStringWithOctave: Dictionary<Int, String> = [
            -4: "29", -3: "22", -2: "15", -1: "8", +4: "29", +3: "22", +2: "15", +1: "8"
        ]
        return getStringWithOctave[transposition]!
    }
    
    func setMiddleCStaffSpace() {
        
    }
    
    func adjustMiddleCStaffSpaceWithTransposition() {
        middleCStaffSpace -= 3.5 * CGFloat(transposition)
    }
}