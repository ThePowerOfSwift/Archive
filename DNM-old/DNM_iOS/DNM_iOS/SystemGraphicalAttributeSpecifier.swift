//
//  SystemGraphicalAttributeSpecifier.swift
//  DNM_iOS
//
//  Created by James Bean on 12/20/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

public struct SystemGraphicalAttributeSpecifier {
    
    public let staffSpaceHeight: StaffSpaceHeight
    public let scale: Scale
    public let beatWidth: BeatWidth
    
    public init(
        beatWidth: BeatWidth = 110,
        sizeSpecifier: StaffTypeSizeSpecifier = StaffTypeSizeSpecifier()
    ) {
        self.staffSpaceHeight = sizeSpecifier.staffSpaceHeight
        self.scale = sizeSpecifier.scale
        self.beatWidth = beatWidth
    }
}