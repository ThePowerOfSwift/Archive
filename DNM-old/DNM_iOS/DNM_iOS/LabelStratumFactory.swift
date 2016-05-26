//
//  LabelStratumFactory.swift
//  DNM
//
//  Created by James Bean on 1/29/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import QuartzCore
import DNMModel

public class LabelStratumFactory: SystemContextualized {
    
    public let labelStratumModels: [LabelStratumModel]
    public let viewerProfile: ViewerProfile
    public let systemOffsetDuration: Duration
    public let infoStartX: CGFloat
    public let beatWidth: BeatWidth
    public let systemWidth: CGFloat
    public let defaultStaffHeight: StaffSpaceHeight
    public let scale: Scale
    
    public init(
        labelStratumModels: [LabelStratumModel],
        systemContextSpecifier: SystemContextSpecifier = SystemContextSpecifier(),
        sizeSpecifier: StaffTypeSizeSpecifier = StaffTypeSizeSpecifier(),
        systemWidth: CGFloat,
        beatWidth: BeatWidth = 110
    )
    {
        self.labelStratumModels = labelStratumModels
        self.viewerProfile = systemContextSpecifier.viewerProfile
        self.systemOffsetDuration = systemContextSpecifier.offsetDuration
        self.infoStartX = systemContextSpecifier.infoStartX
        self.defaultStaffHeight = sizeSpecifier.staffSpaceHeight
        self.scale = sizeSpecifier.scale
        self.beatWidth = beatWidth
        self.systemWidth = systemWidth
    }
    
    public func makeLabelStrata() -> [LabelStratum] {
        let labelStratumViewModels = makeLabelStratumViewModels()
        return labelStratumViewModels.map { LabelStratum(viewModel: $0) }
    }
    
    public func makeLabelStratumViewModels() -> [LabelStratumViewModel] {
        return labelStratumModels.map {
            LabelStratumViewModel(
                model: $0,
                origin: CGPointZero,
                height: 30,
                systemContextSpecifiier: SystemContextSpecifier(
                    viewerProfile: viewerProfile,
                    offsetDuration: systemOffsetDuration,
                    infoStartX: infoStartX
                ),
                systemWidth: systemWidth,
                beatWidth: beatWidth
            )
        }
    }
}