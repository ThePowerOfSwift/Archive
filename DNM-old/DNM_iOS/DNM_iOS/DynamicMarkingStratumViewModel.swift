//
//  DynamicMarkingStratumViewModel.swift
//  DNM_iOS
//
//  Created by James Bean on 12/28/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import QuartzCore
import DNMModel

/**
ViewModel for DynanicMarkingStratum. 
Contains ViewModels for DynamicMarkings and DynamicMarkingSpanners.
*/
public struct DynamicMarkingStratumViewModel {
    
    public let model: DynamicMarkingStratumModel

    public let origin: CGPoint
    public let height: CGFloat
    public let beatWidth: BeatWidth
    public let infoStartX: CGFloat
    public let offsetDuration: Duration
    public let systemWidth: CGFloat
    
    public var dynamicMarkingViewModels: [DynamicMarkingViewModel] = []
    public var dynamicMarkingSpannerViewModels: [DynamicMarkingSpannerViewModel] = []
    
    private var spannerHeight: CGFloat { return 0.382 * height }
    
    /**
    Create a DynamicMarkingStratumViewModel

    - parameter model:     Model of DynamicMarkingStratum
    - parameter origin:    Origin of DynamicMarkingStratum
    - parameter height:    Height of DynamicMarkingStratum
    - parameter beatWidth: Graphical width of a single 8th-note

    - returns: DynamicMarkingStratumViewModel
    */
    public init(
        model: DynamicMarkingStratumModel,
        origin: CGPoint,
        height: CGFloat,
        systemContextSpecifiier: SystemContextSpecifier,
        systemWidth: CGFloat,
        beatWidth: BeatWidth
    )
    {
        self.model = model
        self.origin = origin
        self.height = height
        self.offsetDuration = systemContextSpecifiier.offsetDuration
        self.infoStartX = systemContextSpecifiier.infoStartX
        self.systemWidth = systemWidth
        self.beatWidth = beatWidth
        build()
    }
    
    private mutating func build() {
        createDynamicMarkingViewModels()
        createDynamicMarkingSpannerViewModels()
    }

    private mutating func createDynamicMarkingViewModels() {
        dynamicMarkingViewModels =  model.dynamicMarkingModels.map {
            let x = xValueAt($0.durationInterval.startDuration)
            return DynamicMarkingViewModel(model: $0, x: x, height: height)
        }
    }
    
    private mutating func createDynamicMarkingSpannerViewModels() {
        dynamicMarkingSpannerViewModels = model.dynamicMarkingSpannerModels.map {
            DynamicMarkingSpannerViewModel(
                model: $0,
                height: spannerHeight,
                targetStartX: startXFor($0),
                targetStopX: stopXFor($0)
            )
        }
    }
    
    private func startXFor(spannerModel: DynamicMarkingSpannerModel) -> CGFloat {
        if spannerIsFirstElement(spannerModel) { return 20 }
        return xValueAt(spannerModel.durationInterval.startDuration)
    }

    private func stopXFor(spannerModel: DynamicMarkingSpannerModel) -> CGFloat {
        if spannerIsLastElement(spannerModel) { return systemWidth + 10 } // temp
        return xValueAt(spannerModel.durationInterval.stopDuration)
    }
    
    private func spannerIsFirstElement(spannerModel: DynamicMarkingSpannerModel) -> Bool {
        let firstEl = model.dynamicMarkingElementModels.first as? DynamicMarkingSpannerModel
        return spannerModel == firstEl
    }
    
    private func spannerIsLastElement(spannerModel: DynamicMarkingSpannerModel) -> Bool {
        let lastEl = model.dynamicMarkingElementModels.last as? DynamicMarkingSpannerModel
        return spannerModel == lastEl
    }
    
    private func xValueAt(duration: Duration) -> CGFloat {
        let xAtDuration = duration.width(beatWidth: beatWidth)
        let xAtSystemStart = offsetDuration.width(beatWidth: beatWidth)
        let xDiff = xAtDuration - xAtSystemStart
        return xDiff + infoStartX
    }
}