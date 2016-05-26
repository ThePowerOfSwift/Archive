//
//  DynamicMarkingSpannerViewModel.swift
//  DNM_iOS
//
//  Created by James Bean on 12/28/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import QuartzCore
import DNMModel

/**
ViewModel for DynamicMarkingSpanner
*/
public struct DynamicMarkingSpannerViewModel: DynamicMarkingElementViewModel {
    
    public let model: DynamicMarkingSpannerModel
    
    public let targetStartX: CGFloat
    public let targetStopX: CGFloat
    public let height: CGFloat
    
    public var segmentViewModels: [DynamicMarkingSpannerSegmentViewModel] = []

    public init(
        model: DynamicMarkingSpannerModel,
        height: CGFloat,
        targetStartX: CGFloat,
        targetStopX: CGFloat
    )
    {
        self.model = model
        self.height = height
        self.targetStartX = targetStartX
        self.targetStopX = targetStopX
        createSegmentViewModels()
    }
    
    // todo: default single segment for entire hairpin
    private mutating func createSegmentViewModels() {
        let (scaleYLeft, scaleYRight) = scaleYLeftAndRightFor(model.direction)
        let segmentViewModel = DynamicMarkingSpannerSegmentViewModel(
            spannerHeight: height,
            scaleYLeft: scaleYLeft,
            scaleYRight: scaleYRight,
            tLeft: 0,
            tRight: 1
        )
        segmentViewModels = [segmentViewModel]
    }
    
    private func scaleYLeftAndRightFor(direction: DynamicMarkingSpannerDirection)
        -> (CGFloat, CGFloat)
    {
        switch direction {
        case .Crescendo: return (0, 1)
        case .Decrescendo: return (1, 0)
        case .Static: return (0, 0)
        }
    }
}