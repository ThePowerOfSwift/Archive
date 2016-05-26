//
//  DynamicMarkingStratum.swift
//  DNM_iOS
//
//  Created by James Bean on 9/10/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit
import DNMModel

/// Horizontal arrangement of DynamicMarkings and DynamicMarkingSpanners
public class DynamicMarkingStratum: ViewNode {
    
    /// Identifier of DynamicMarkginStratum. Usually PerformerID.
    public var identifier: String!
    
    /// ViewModel of DynamicMarkingStratum. Wrap model and adds graphical attributes
    public var viewModel: DynamicMarkingStratumViewModel!
    
    /// DynamicMarkingLayers contained in this DynamicMarkingStratum
    public var dynamicMarkingLayers: [DynamicMarkingLayer] = []
    
    /// DynamicMarkingSpannerLayers contained in this DynamicMarkingStratum
    public var dynamicMarkingSpannerLayers: [DynamicMarkingSpannerLayer] = []

    private var spannerHeight: CGFloat { get { return 0.382 * viewModel.height } }
    
    /**
    Create a DynamicMarkingStratum

    - parameter viewModel: DynamicMarkingStratumViewModel

    - returns: DynamicMarkingStratum
    */
    public init(viewModel: DynamicMarkingStratumViewModel) {
        self.viewModel = viewModel
        self.identifier = viewModel.model.identifier // temp
        super.init()
        build()
    }
    
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    public override init(layer: AnyObject) { super.init(layer: layer) }

    /**
    Get the DynamicMarkingLayer at a given Duration

    - parameter duration: Duration

    - returns: DynamicMarkingLayer, if available
    */
    public func dynamicMarkingLayerAt(duration: Duration) -> DynamicMarkingLayer? {
        for dynamicMarkingLayer in dynamicMarkingLayers {
            if dynamicMarkingLayer.viewModel.model.durationInterval.startDuration == duration {
                return dynamicMarkingLayer
            }
        }
        return nil
    }
    
    private func build() {
        configureViewNodeLayout()
        commitDynamicMarkingLayers()
        commitDynamicMarkingSpannerLayers()
        layout()
    }
    
    private func configureViewNodeLayout() {
        self.setsHeightWithContents = true
        self.flowDirectionVertical = .Top
        self.pad_bottom = 0.5 * viewModel.height
    }

    private func commitDynamicMarkingLayers() {
        createDynamicMarkingLayers()
        dynamicMarkingLayers.forEach { addNode($0) }
    }
    
    private func createDynamicMarkingLayers() {
        dynamicMarkingLayers = viewModel.dynamicMarkingViewModels.map {
            DynamicMarkingLayer(viewModel: $0)
        }
    }
    
    private func commitDynamicMarkingSpannerLayers() {
        createDynamicMarkingSpannerLayers()
        dynamicMarkingSpannerLayers.forEach { addSublayer($0) }
        positionSpannerLayers()
    }
    
    private func createDynamicMarkingSpannerLayers() {
        let pad: CGFloat = 0.618 * spannerHeight
        dynamicMarkingSpannerLayers = viewModel.dynamicMarkingSpannerViewModels.map {
            let startDur = $0.model.durationInterval.startDuration
            let stopDur = $0.model.durationInterval.stopDuration
            let left: CGFloat = (dynamicMarkingLayerAt(startDur)?.frame.maxX ?? $0.targetStartX) + pad
            let right: CGFloat = (dynamicMarkingLayerAt(stopDur)?.frame.minX ?? $0.targetStopX) - pad
            return DynamicMarkingSpannerLayer(viewModel: $0, left: left, right: right)
        }
    }
    
    private func positionSpannerLayers() {
        dynamicMarkingSpannerLayers.forEach { $0.position.y = position.y }
    }
}