//
//  DynamicMarkingSpannerSegmentLayer.swift
//  DNM_iOS
//
//  Created by James Bean on 12/30/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit

// created by SpannerLayer
public class DynamicMarkingSpannerSegmentLayer: CAShapeLayer {
    
    public var viewModel: DynamicMarkingSpannerSegmentViewModel!
    
    public var left: CGFloat = 0
    public var right: CGFloat = 0
    
    public init(
        viewModel: DynamicMarkingSpannerSegmentViewModel,
        left: CGFloat,
        right: CGFloat
    )
    {
        self.viewModel = viewModel
        self.left = left
        self.right = right
        super.init()
        build()
    }
    
    public override init() { super.init() }
    public override init(layer: AnyObject) { super.init(layer: layer) }
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    public func build() {
        path = makePath()
        setFrame()
        setVisualAttributes()
    }
    
    private func setFrame() {
        frame = CGRect(x: left, y: 0, width: right - left, height: viewModel.spannerHeight)
    }
    
    private func setVisualAttributes() {
        strokeColor = UIColor.lightGrayColor().CGColor
        fillColor = UIColor.whiteColor().CGColor
        lineJoin = kCALineJoinBevel
        lineWidth = 0.1236 * viewModel.spannerHeight
        manageLineStyle()
    }
    
    private func manageLineStyle() {
        switch viewModel.lineStyle {
        case .Dashed: lineDashPattern = [0.309 * viewModel.spannerHeight]
        default: break
        }
    }
    
    private func makePath() -> CGPath {
        let path = UIBezierPath()
        addTopLineTo(path)
        addBottomLineTo(path)
        return path.CGPath
        
    }
    
    private func addTopLineTo(path: UIBezierPath) {
        // top left
        let yLeft = (0.5 - 0.5 * viewModel.scaleYLeft) * viewModel.spannerHeight
        path.moveToPoint(CGPoint(x: left, y: yLeft))
        
        // top right
        let yRight = (0.5 - 0.5 * viewModel.scaleYRight) * viewModel.spannerHeight
        path.addLineToPoint(CGPoint(x: right, y: yRight))
    }
    
    private func addBottomLineTo(path: UIBezierPath) {
        // bottom right
        let yLeft = (0.5 + 0.5 * viewModel.scaleYLeft) * viewModel.spannerHeight
        path.moveToPoint(CGPoint(x: left, y: yLeft))
        
        // bottom left
        let yRight = (0.5 + 0.5 * viewModel.scaleYRight) * viewModel.spannerHeight
        path.addLineToPoint(CGPoint(x: right, y: yRight))
    }
    
}