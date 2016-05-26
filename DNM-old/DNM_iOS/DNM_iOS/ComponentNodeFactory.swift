//
//  ComponentNodeFactory.swift
//  DNM_iOS
//
//  Created by James Bean on 12/23/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import QuartzCore
import DNMModel

public class ComponentNodeRenderer: ComponentFiltering, SystemContextualized {
    
    public var durationNodes: [DurationNode]
    public let viewerProfile: ViewerProfile
    public let systemOffsetDuration: Duration
    public let infoStartX: CGFloat
    public let beatWidth: BeatWidth
    public let defaultStaffHeight: StaffSpaceHeight
    public let scale: Scale
    
    public init(
        durationNodes: [DurationNode],
        systemContextSpecifier: SystemContextSpecifier = SystemContextSpecifier(),
        sizeSpecifier: StaffTypeSizeSpecifier = StaffTypeSizeSpecifier(),
        beatWidth: BeatWidth = 110
    )
    {
        self.durationNodes = durationNodes
        self.viewerProfile = systemContextSpecifier.viewerProfile
        self.systemOffsetDuration = systemContextSpecifier.offsetDuration
        self.infoStartX = systemContextSpecifier.infoStartX
        self.defaultStaffHeight = sizeSpecifier.staffSpaceHeight
        self.scale = sizeSpecifier.scale
        self.beatWidth = beatWidth
    }
}