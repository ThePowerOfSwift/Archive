//
//  CircleClefOrnament.swift
//  StaffClef
//
//  Created by James Bean on 6/13/16.
//
//

import QuartzCore
import PathTools
import Color

public final class CircleClefOrnament: CAShapeLayer, CircleClefComponent {
    
    public let point: CGPoint
    public let radius: CGFloat
    
    public init(point: CGPoint, radius: CGFloat, lineWidth: CGFloat, color: CGColor) {
        self.point = point
        self.radius = radius
        super.init()
        self.strokeColor = color
        self.fillColor = Color(gray: 0, alpha: 1).cgColor
        self.lineWidth = lineWidth
        build()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
