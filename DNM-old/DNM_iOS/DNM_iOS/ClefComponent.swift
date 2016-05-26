//
//  ClefComponent.swift
//  DNM
//
//  Created by James Bean on 1/10/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import UIKit

public class ClefComponent: CAShapeLayer {
    
    public var color: CGColor = UIColor.blackColor().CGColor
    
    public var hasBeenBuilt: Bool = false
    
    public func build() {
        hasBeenBuilt = true
    }
    
    internal func makePath() -> CGPath {
        // override in subclasses
        return UIBezierPath().CGPath
    }
    
    internal func setFrame() {
        // override
    }
    
    internal func setVisualAttributes() {
        // override
    }
}
