//
//  LineClefComponent.swift
//  StaffClef
//
//  Created by James Bean on 6/13/16.
//
//

import QuartzCore
import GraphicsTools
import PathTools

public final class LineClefComponent: CAShapeLayer, ShapeType {
    
    public let height: CGFloat

    public init(
        height: CGFloat,
        lineWidth: CGFloat,
        color: CGColor
    )
    {
        self.height = height
        super.init()
        self.strokeColor = color
        self.lineWidth = lineWidth
        build()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func makeFrame() -> CGRect {
        return CGRect(x: 0, y: 0, width: 0, height: height)
    }
    
    public func makePath() -> CGPath {
        return Path()
            .move(to: CGPoint.zero)
            .addLine(to: CGPoint(x: 0, y: frame.height))
            .cgPath
    }
}
