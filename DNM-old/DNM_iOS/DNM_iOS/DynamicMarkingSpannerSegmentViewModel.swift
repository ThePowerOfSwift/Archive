//
//  DynamicMarkingSpannerSegmentViewModel.swift
//  DNM_iOS
//
//  Created by James Bean on 12/30/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import QuartzCore

public struct DynamicMarkingSpannerSegmentViewModel {
    
    public let spannerHeight: CGFloat

    // vertical scale at left and right
    public let scaleYLeft: CGFloat
    public let scaleYRight: CGFloat
    
    // horizontal position (0...1) of left, right in Spanner
    public let tLeft: CGFloat
    public let tRight: CGFloat
    
    public let lineStyle: DynamicMarkingSpannerSegmentLineStyle
    
    public init(
        spannerHeight: CGFloat,
        scaleYLeft: CGFloat,
        scaleYRight: CGFloat,
        tLeft: CGFloat = 0,
        tRight: CGFloat = 1,
        lineStyle: DynamicMarkingSpannerSegmentLineStyle = .Solid
    )
    {
        self.spannerHeight = spannerHeight
        self.scaleYLeft = scaleYLeft
        self.scaleYRight = scaleYRight
        self.tLeft = tLeft
        self.tRight = tRight
        self.lineStyle = lineStyle
    }
}

public enum DynamicMarkingSpannerSegmentLineStyle {
    case Dashed, Solid
}