//
//  SystemContextSpecifier.swift
//  DNM_iOS
//
//  Created by James Bean on 12/23/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import QuartzCore
import DNMModel

public struct SystemContextSpecifier {
    
    public let viewerProfile: ViewerProfile
    public let offsetDuration: Duration
    public let infoStartX: CGFloat
    
    public init(
        viewerProfile: ViewerProfile = ViewerProfile(viewer: ViewerOmni, peers: []),
        offsetDuration: Duration = DurationZero,
        infoStartX: CGFloat = 0
    )
    {
        self.viewerProfile = viewerProfile
        self.offsetDuration = offsetDuration
        self.infoStartX = infoStartX
    }
}