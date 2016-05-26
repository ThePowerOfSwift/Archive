//
//  ClefOrnamentCircle.swift
//  DNM
//
//  Created by James Bean on 1/10/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import UIKit

public class ClefOrnamentCircle: ClefOrnament {
    
    override internal func makePath() -> CGPath {
        setFrame()
        let path = UIBezierPath(ovalInRect: CGRectMake(0, 0, width, width))
        return path.CGPath
    }
}