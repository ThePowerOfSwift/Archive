//
//  GraphLine.swift
//  DNM
//
//  Created by James Bean on 1/10/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import UIKit

public class GraphLine: CAShapeLayer {
    
    private let left: CGFloat
    private let right: CGFloat
    private let y: CGFloat
    
    public init(
        left: CGFloat,
        right: CGFloat,
        y: CGFloat
    )
    {
        self.left = left
        self.right = right
        self.y = y
        super.init()
        build()
    }

    public required init?(coder aDecoder: NSCoder) {
        self.left = 0
        self.right = 0
        self.y = 0
        super.init(coder: aDecoder)
    }
    
    internal func build() {
        self.path = makePath()
        setVisualAttributes()
    }
    
    // TODO: manage strokeWidth and strokeColor
    private func setVisualAttributes() {
        strokeColor = UIColor.grayColor().CGColor
    }
    
    private func makePath() -> CGPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: left, y: y))
        path.addLineToPoint(CGPoint(x: right, y: y))
        return path.CGPath
    }
}