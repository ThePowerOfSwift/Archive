//
//  ClefGraphLine.swift
//  DNM
//
//  Created by James Bean on 1/10/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import UIKit

public class ClefGraphLine: ClefComponent {
    
    public var x: CGFloat = 0
    public var top: CGFloat = 0
    public var height: CGFloat = 0
    
    public init(x: CGFloat, top: CGFloat, height: CGFloat) {
        super.init()
        self.x = x
        self.top = top
        self.height = height
        build()
    }
    
    public override init() { super.init() }
    public override init(layer: AnyObject) { super.init(layer: layer) }
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    public override func build() {
        setFrame()
        path = makePath()
        setVisualAttributes()
        hasBeenBuilt = true
    }
    
    override internal func makePath() -> CGPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, 0))
        path.addLineToPoint(CGPointMake(0, frame.height))
        return path.CGPath
    }
    
    override internal func setFrame() {
        frame = CGRectMake(x, top, 0, height)
    }
    
    override internal func setVisualAttributes() {
        strokeColor = color
        fillColor = UIColor.clearColor().CGColor
        backgroundColor = UIColor.clearColor().CGColor
    }
}