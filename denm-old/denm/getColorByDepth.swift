import UIKit
import QuartzCore

func getColorByDepth(depth: Int) -> CGColor {
    let colorByDepth = [
        UIColor.lightGrayColor().CGColor,
        UIColor.purpleColor().CGColor,
        UIColor.orangeColor().CGColor,
        UIColor.lightGrayColor().CGColor,
        UIColor.lightGrayColor().CGColor,
        UIColor.lightGrayColor().CGColor,
        UIColor.lightGrayColor().CGColor,
    ]
    return colorByDepth[depth]
}