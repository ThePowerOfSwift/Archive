import QuartzCore
import UIKit

class TestLineWidth: TestLine {
    
    var left: CGFloat = 0
    var width: CGFloat = 0
    var right: CGFloat = 0
    var y: CGFloat = 0
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    override init(objectFrame: CGRect) {
        super.init()
        self.objectFrame = objectFrame
        setSizeWithObjectFrame()
        self.left = 0 + 0.5
        self.width = objectFrame.width
        self.right = objectFrame.width - 0.5
        self.y = objectFrame.height + 1.5 * size
    }
    
    override func addPrimary() -> TestLine {
        let primary = TestLinePrimary(x0: left, y0: y, x1: right, y1: y)
        components.append(primary)
        return self
    }
    
    override func addEdges() -> TestLine {
        let edge1 = TestLineEdge(x0: left, y0: y - 0.618 * size, x1: left, y1: y + 0.618 * size)
        let edge2 = TestLineEdge(x0: right, y0: y - 0.618 * size, x1: right, y1: y + 0.618 * size)
        components.append(edge1)
        components.append(edge2)
        return self
    }
    
    override func addArrows() -> TestLine {
        let arrow1 = TestLineArrow(x: left, y: y, width: size, rotate: 270)
        let arrow2 = TestLineArrow(x: right, y: y, width: size, rotate: 90)
        components.append(arrow1)
        components.append(arrow2)
        return self
    }
    
    override func addLabelsInfo() -> TestLine {
        let wInfo = TestLineLabelInfo(
            positionValue: objectFrame.width,
            x: 0.5 * objectFrame.width,
            top: objectFrame.height + 2.75 * size,
            description: "W"
        )
        let minXInfo = TestLineLabelInfo(
            positionValue: objectFrame.minX,
            x: 0,
            top: objectFrame.height + 2.75 * size,
            description: "minX"
        )
        let maxXInfo = TestLineLabelInfo(
            positionValue: objectFrame.maxX,
            x: objectFrame.width,
            top: objectFrame.height + 2.75 * size,
            description: "maxX"
        )
        
        if objectFrame.width < 50 { labelsInfo = [wInfo] }
        else { labelsInfo = [wInfo, minXInfo, maxXInfo] }
        
        return self
    }
}