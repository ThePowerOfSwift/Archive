//
//  DiamondClefOrnament.swift
//  StaffClef
//
//  Created by James Bean on 6/13/16.
//
//

import QuartzCore
import GraphicsTools
import PathTools
import Color

public final class DiamondClefOrnament: CAShapeLayer, ShapeType {
    
    public let point: CGPoint
    public let width: CGFloat
    
    public init(point: CGPoint, width: CGFloat, lineWidth: CGFloat, color: CGColor) {
        self.point = point
        self.width = width
        super.init()
        self.strokeColor = color
        self.fillColor = Color(gray: 0, alpha: 1).cgColor
        self.lineWidth = lineWidth
        build()
    }
    
    public func makeFrame() -> CGRect {
        return CGRect(
            x: point.x - 0.5 * width,
            y: point.y - 0.5 * width,
            width: width,
            height: width
        )
    }
    
    public func makePath() -> CGPath {
        return Path.square(
            center: CGPoint(x: 0.5 * width, y: 0.5 * width),
            width: width
        ).rotated(by: 45).cgPath
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
