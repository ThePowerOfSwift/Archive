//
//  Clef.swift
//  DNM_iOS
//
//  Created by James Bean on 8/17/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit

/// Clef for Graphs. Clef base-class is a straight vertical red line, 10 points high.
public class Clef: CALayer {
    
    internal var color: CGColorRef = UIColor.redColor().CGColor
    internal var top: CGFloat = 0
    internal var x: CGFloat = 0
    internal var height: CGFloat { return 20 } // override
    
    internal var lineWidth: CGFloat { return 1 } // override
    
    internal var components: [ClefComponent] = []
    
    public init(origin: CGPoint) {
        self.x = origin.x
        self.top = origin.y
        super.init()
        build()
    }
    
    public override init(layer: AnyObject) { super.init(layer: layer) }
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    internal func build() {
        setFrame()
        commitComponents()
    }
    
    internal func setFrame() {
        frame = CGRectMake(x, top, 0, height)
    }

    internal func commitComponents() {
        addComponents()
        components.forEach { addSublayer($0) }
    }
    
    internal func addComponents() {
        addGraphLine()
    }
    
    internal func addGraphLine() {
        let line = ClefGraphLine(x: 0, top: 0, height: height)
        line.lineWidth = lineWidth
        line.strokeColor = color
        components.append(line)
    }
}