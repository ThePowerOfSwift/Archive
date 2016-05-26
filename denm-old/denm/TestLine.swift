import QuartzCore
import UIKit

class TestLine: CALayer {
    
    var size: CGFloat = 0
    var color: CGColor = UIColor.lightGrayColor().CGColor
    var objectFrame: CGRect = CGRectMake(0, 0, 0, 0)
    var labelAlignment: String = "center"
    
    var components: [TestLineComponent] = []
    var labelsInfo: [TestLineLabelInfo] = []
    var labels: [TextLayerByHeight] = []
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init() { super.init() }
    
    init(objectFrame: CGRect) {
        /* override */
        self.objectFrame = objectFrame
        super.init()
    }
    
    func setObjectFrame(objectFrame: CGRect) -> TestLine {
        self.objectFrame = objectFrame
        setSizeWithObjectFrame()
        return self
    }
    
    func setColor(color: CGColor) -> TestLine {
        self.color = color
        return self
    }
    
    func addComponents() -> TestLine {
        addPrimary()
        addEdges()
        addArrows()
        addLabelsInfo()
        addLabels()
        return self
    }
    
    func addPrimary() -> TestLine {
        // override
        return self
    }
    
    func addEdges() -> TestLine {
        // override
        return self
    }
    
    func addArrows() -> TestLine {
        // override
        return self
    }
    
    func addLabelsInfo() -> TestLine {
        /* override */
        return self
    }
    
    func addLabels() -> TestLine {
        let fontName: String = "AvenirNext-Italic"
        
        for labelInfo in labelsInfo {
            let label: TextLayerByHeight = TestLineLabel(
                height: size,
                top: labelInfo.top,
                alignment: labelAlignment,
                color: UIColor.darkGrayColor().CGColor
                ).setStringWithPosition(labelInfo.positionValue, x: labelInfo.x).build()
            
            let description: TextLayerByHeight = TestLineLabel(
                height: 0.75 * size,
                top: labelInfo.top + 1.5 * size,
                alignment: labelAlignment,
                color: UIColor.lightGrayColor().CGColor
                ).setStringWithString(labelInfo.description, x: labelInfo.x).build()
            
            labels.append(label)
            labels.append(description)
        }
        
        return self
    }
    
    
    func build() -> TestLine {
        for component in components {
            component.strokeColor = color
            addSublayer(component)
        }
        for label in labels {
            addSublayer(label)
        }
        return self
    }
    
    func setSizeWithObjectFrame() {
        let minSize: CGFloat = 4
        let maxSize: CGFloat = 10
        let shortest = sorted([objectFrame.width, objectFrame.height])[0]
        size = 0.15 * shortest
        if size < minSize { size = minSize }
        if size > maxSize { size = maxSize }
    }
}