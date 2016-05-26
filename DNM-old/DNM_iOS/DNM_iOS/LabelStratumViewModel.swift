//
//  LabelStratumViewModel.swift
//  DNM
//
//  Created by James Bean on 1/29/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import QuartzCore
import DNMModel

public class LabelStratumViewModel {
    
    public let model: LabelStratumModel
    
    public let origin: CGPoint
    public let height: CGFloat
    public let beatWidth: BeatWidth
    public let infoStartX: CGFloat
    public let offsetDuration: Duration
    public let systemWidth: CGFloat
    
    public var labelViewModels: [LabelViewModel] = []
    
    public init(
        model: LabelStratumModel,
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

    private func build() {
        setLabelViewModels()
    }
    
    private func setLabelViewModels() {
        self.labelViewModels = model.labelModels.map {
            LabelViewModel(
                model: $0,
                x: xValueAt($0.durationInterval.startDuration),
                height: height
            )
        }
    }
    
    private func xValueAt(duration: Duration) -> CGFloat {
        let xAtDuration = duration.width(beatWidth: beatWidth)
        let xAtSystemStart = offsetDuration.width(beatWidth: beatWidth)
        let xDiff = xAtDuration - xAtSystemStart
        return xDiff + infoStartX
    }
}