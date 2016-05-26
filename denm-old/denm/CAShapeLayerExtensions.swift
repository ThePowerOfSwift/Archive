import UIKit
import QuartzCore

extension CAShapeLayer {
    func makeAnimationToNewPath(newPath: CGPath) -> CABasicAnimation {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation.duration = 0.125
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        animation.toValue = newPath
        return animation
    }
}