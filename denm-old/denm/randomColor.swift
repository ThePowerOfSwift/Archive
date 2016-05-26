import QuartzCore
import UIKit

func randomColor() -> CGColor {
    
    let colors = [
        UIColor.blackColor().CGColor,
        UIColor.grayColor().CGColor,
        UIColor.blueColor().CGColor,
        UIColor.redColor().CGColor,
        UIColor.purpleColor().CGColor,
        UIColor.orangeColor().CGColor
    ]
    
    let color = UIColor.blueColor().CGColor
    return color
}