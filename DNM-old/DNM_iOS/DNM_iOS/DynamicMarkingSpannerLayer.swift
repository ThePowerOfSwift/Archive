//
//  DynamicMarkingSpannerLayer.swift
//  DNM_iOS
//
//  Created by James Bean on 12/30/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit

public class DynamicMarkingSpannerLayer: CALayer {
    
    public var viewModel: DynamicMarkingSpannerViewModel!

    public var left: CGFloat = 0
    public var right: CGFloat = 0
    private var width: CGFloat { return right - left }
    
    private var segmentLayers: [DynamicMarkingSpannerSegmentLayer] = []
    
    public init(
        viewModel: DynamicMarkingSpannerViewModel,
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
    
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    public func build() {
        setFrame()
        commitSegmentLayers()
        positionSegmentLayers()
    }
    
    private func commitSegmentLayers() {
        createSegmentLayers()
        segmentLayers.forEach { addSublayer($0) }
    }
    
    private func createSegmentLayers() {
        segmentLayers = viewModel.segmentViewModels.map {
            DynamicMarkingSpannerSegmentLayer(
                viewModel: $0,
                left: width * $0.tLeft,
                right: width * $0.tRight
            )
        }
    }
    
    private func positionSegmentLayers() {
        segmentLayers.forEach { $0.position.y = position.y }
    }
    
    private func setFrame() {
        frame = CGRectMake(left, 0, width, viewModel.height)
    }
}