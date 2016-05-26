//
//  ClefOrnamentDot.swift
//  DNM
//
//  Created by James Bean on 1/10/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import UIKit

public class ClefOrnamentDot: ClefOrnament {
    
    override internal func makePath() -> CGPath {
        setFrame()
        let path = UIBezierPath(ovalInRect: CGRectMake(0, 0, width, width))
        return path.CGPath
    }
    
    internal override func setVisualAttributes() {
        fillColor = color
        lineWidth = 0
        backgroundColor = UIColor.clearColor().CGColor
    }
}