import QuartzCore
import UIKit

class TestLineHeight: TestLine {
    
    var x: CGFloat = 0
    var top: CGFloat = 0
    var height: CGFloat = 0
    var bottom: CGFloat = 0
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    override init(objectFrame: CGRect) {
        super.init()
        self.objectFrame = objectFrame
        setSizeWithObjectFrame()
        self.x = objectFrame.width + 1.5 * size
        self.top = 0 + 0.5
        self.bottom = objectFrame.height - 0.5
        self.labelAlignment = "left"
    }
    
    override func addPrimary() -> TestLine {
        let primary = TestLinePrimary(x0: x, y0: top, x1: x, y1: bottom)
        components.append(primary)
        return self
    }
    
    override func addEdges() -> TestLine {
        let edge1 = TestLineEdge(x0: x - 0.618 * size, y0: top, x1: x + 0.618 * size, y1: top)
        let edge2 = TestLineEdge(x0: x - 0.618 * size, y0: bottom, x1: x + 0.618 * size, y1: bottom)
        components.append(edge1)
        components.append(edge2)
        return self
    }
    
    override func addArrows() -> TestLine {
        let arrow1 = TestLineArrow(x: x, y: top, width: size, rotate: 0)
        let arrow2 = TestLineArrow(x: x, y: bottom, width: size, rotate: 180)
        components.append(arrow1)
        components.append(arrow2)
        return self
    }
    
    override func addLabelsInfo() -> TestLine {
        let hInfo = TestLineLabelInfo(
            positionValue: objectFrame.height,
            x: objectFrame.width + 2.75 * size,
            top: 0.5 * objectFrame.height - 0.5 * size,
            description: "H"
        )
        let minYInfo = TestLineLabelInfo(
            positionValue: objectFrame.minY,
            x: objectFrame.width + 2.75 * size,
            top: 0 - 0.5 * size,
            description: "minY"
        )
        let maxYInfo = TestLineLabelInfo(
            positionValue: objectFrame.maxY,
            x: objectFrame.width + 2.75 * size,
            top: objectFrame.height - 0.5 * size,
            description: "maxY"
        )
        
        if objectFrame.height < 35 { labelsInfo = [hInfo] }
        else { labelsInfo = [hInfo, minYInfo, maxYInfo] }
        
        return self
    }
}