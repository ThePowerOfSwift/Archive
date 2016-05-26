//
//  SystemViewModel.swift
//  DNM_iOS
//
//  Created by James Bean on 12/20/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation
import DNMModel

public struct SystemViewModel {
    
    public var model: SystemModel
    
    public var viewerProfile: ViewerProfile
    
    public var componentFilters: ComponentFilters
    
    public var staffSpaceHeight: StaffSpaceHeight
    public var scale: Scale
    public var beatWidth: BeatWidth
    
    public init(
        model: SystemModel,
        viewerProfile: ViewerProfile,
        componentFilters: ComponentFilters,
        graphicalAttributeSpecifier: SystemGraphicalAttributeSpecifier
    )
    {
        self.model = model
        self.viewerProfile = viewerProfile
        self.componentFilters = componentFilters
        self.beatWidth = graphicalAttributeSpecifier.beatWidth
        self.staffSpaceHeight = graphicalAttributeSpecifier.staffSpaceHeight
        self.scale = graphicalAttributeSpecifier.scale
    }
}