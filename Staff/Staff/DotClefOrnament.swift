//
//  DotClefOrnament.swift
//  StaffClef
//
//  Created by James Bean on 6/13/16.
//
//

import QuartzCore
import PathTools

public final class DotClefOrnament: CAShapeLayer, CircleClefComponent {
    
    public var point: CGPoint
    public var radius: CGFloat
    
    public init(point: CGPoint, radius: CGFloat, color: CGColor) {
        self.point = point
        self.radius = radius
        super.init()
        self.fillColor = color
        self.lineWidth = 0
        build()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
