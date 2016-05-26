//
//  ClefOrnamentDiamond.swift
//  DNM
//
//  Created by James Bean on 1/10/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import UIKit

public class ClefOrnamentDiamond: ClefOrnament {
    
    override internal func makePath() -> CGPath {
        setFrame()
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(0.5 * width, 0))
        path.addLineToPoint(CGPointMake(width, 0.5 * width))
        path.addLineToPoint(CGPointMake(0.5 * width, width))
        path.addLineToPoint(CGPointMake(0, 0.5 * width))
        path.closePath()
        return path.CGPath
    }
}
