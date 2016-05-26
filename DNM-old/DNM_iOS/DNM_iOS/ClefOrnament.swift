//
//  ClefOrnament.swift
//  DNM
//
//  Created by James Bean on 1/10/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import UIKit

public class ClefOrnament: ClefComponent {
    
    public var x: CGFloat = 0
    public var y: CGFloat = 0
    public var width: CGFloat = 0
    
    public class func withType(type: ClefOrnamentType) -> ClefOrnament? {
        switch type {
        case .Circle: return ClefOrnamentCircle()
        case .Dot: return ClefOrnamentDot()
        case .Diamond: return ClefOrnamentDiamond()
        }
    }
    
    public class func withType(type: ClefOrnamentType, x: CGFloat, y: CGFloat, width: CGFloat)
        -> ClefOrnament?
    {
        let clefOrnament = ClefOrnament.withType(type)
        if clefOrnament != nil {
            clefOrnament!.x = x
            clefOrnament!.y = y
            clefOrnament!.width = width
            clefOrnament!.build()
            return clefOrnament!
        }
        return nil
    }
    
    public override func build() {
        path = makePath()
        setFrame()
        setVisualAttributes()
        hasBeenBuilt = true
    }
    
    internal override func setVisualAttributes() {
        fillColor = DNMColorManager.backgroundColor.CGColor
        strokeColor = color
        backgroundColor = UIColor.clearColor().CGColor
    }
    
    internal override func setFrame() {
        frame = CGRectMake(x - 0.5 * width, y - 0.5 * width, width, width)
    }
}

