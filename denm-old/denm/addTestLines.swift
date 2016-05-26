import QuartzCore
import UIKit

extension CALayer {
    
    func addAllTestLines() {
        addTestLineHeight()
        addTestLineWidth()
    }
    
    func addTestLineHeight() {
        let testLineHeight = TestLineHeight(objectFrame: frame)
            .addComponents()
            .setColor(UIColor.redColor().CGColor)
            .build()
        addSublayer(testLineHeight)
    }
    
    func addTestLineWidth() {
        let testLineWidth = TestLineWidth(objectFrame: frame)
            .addComponents()
            .setColor(UIColor.blueColor().CGColor)
            .build()
        addSublayer(testLineWidth)
    }
}