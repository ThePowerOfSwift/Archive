//
//  SelectionRectangle.swift
//  DNM_iOS
//
//  Created by James Bean on 10/5/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit

public class SelectionRectangle: CAShapeLayer {
    
    public var initialPoint: CGPoint!
    
    public init(initialPoint: CGPoint) {
        super.init()
        self.initialPoint = initialPoint
        build()
    }
    
    public init(x: CGFloat, height: CGFloat) {
        super.init()
        self.initialPoint = CGPoint(x: x, y: 0)
        setFrameWithWidth(0, andHeight: height)
        setVisualAttributes()
    }
    
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    public override init(layer: AnyObject) { super.init(layer: layer) }
    
    public func build() {
        setFrameWithWidth(0, andHeight: 0)
        setVisualAttributes()
    }
    
    public func scaleToPoint(point newPoint: CGPoint) {
        let width = newPoint.x - initialPoint.x
        let height = newPoint.y - initialPoint.y
        setFrameWithWidth(width, andHeight: height)
    }
    
    public func scaleWidthWithPoint(point newPoint: CGPoint) {
        let width = newPoint.x - initialPoint.x
        setFrameWithWidth(width)
    }
    
    public func setFrameWithWidth(width: CGFloat) {
        CATransaction.setDisableActions(true)
        frame = CGRect(x: initialPoint.x, y: initialPoint.y, width: width, height: frame.height)
        CATransaction.setDisableActions(false)
    }
    
    public func setFrameWithWidth(width: CGFloat, andHeight height: CGFloat) {
        CATransaction.setDisableActions(true)
        frame = CGRectMake(initialPoint.x, initialPoint.y, width, height)
        CATransaction.setDisableActions(false)
    }
    
    public func setVisualAttributes() {
        backgroundColor = DNMColor.grayscaleColorWithDepthOfField(.Foreground).CGColor
        borderColor = UIColor.blackColor().CGColor
        borderWidth = 1
        opacity = 0.25
    }
}
