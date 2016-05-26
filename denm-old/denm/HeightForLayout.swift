import UIKit
import QuartzCore

protocol HeightForLayout {
    var frame: CGRect { get }
}

extension CALayer: HeightForLayout { }
extension PadVertical: HeightForLayout {}