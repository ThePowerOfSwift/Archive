//
//  SystemLayerCoordinator.swift
//  DNM_iOS
//
//  Created by James Bean on 12/2/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import QuartzCore
import DNMModel

/// Creates SystemLayers
public class SystemLayerFactory {

    private let systemModels: [SystemModel]
    private let viewerProfile: ViewerProfile
    private let componentFilters: ComponentFilters
    private let beatWidth: CGFloat
    private let staffSpaceHeight: StaffSpaceHeight
    private let scale: Scale
    
    /**
    Create a SystemLayerFactory

    - parameter systemModels:                SystemModel (ScoreModel slice)
    - parameter viewerProfile:               ViewerProfile
    - parameter componentFilters:              ComponentFilters
    - parameter graphicalAttributeSpecifier: Graphical attributes of SystemLayers

    - returns: SystemLayerFactory
    */
    public init(
        systemModels: [SystemModel],
        viewerProfile: ViewerProfile,
        componentFilters: ComponentFilters,
        graphicalAttributeSpecifier: SystemGraphicalAttributeSpecifier = SystemGraphicalAttributeSpecifier()
    )
    {
        self.systemModels = systemModels
        self.viewerProfile = viewerProfile
        self.componentFilters = componentFilters
        self.beatWidth = graphicalAttributeSpecifier.beatWidth
        self.staffSpaceHeight = graphicalAttributeSpecifier.staffSpaceHeight
        self.scale = graphicalAttributeSpecifier.staffSpaceHeight
    }
    
    /**
    Make an array of SystemLayers configured as desired

    - returns: Array of SystemLayers
    */
    public func makeSystemLayers() -> [SystemLayer] {
        let systemLayers = makeSystemLayersFromSystemModels()
        return systemLayers
    }
    
    private func makeSystemLayersFromSystemModels() -> [SystemLayer] {
        return systemModels.map {
            let systemComponentSpans = componentFilters.componentFiltersIn($0.durationInterval)
            return SystemLayer(
                viewModel: SystemViewModel(
                    model: $0,
                    viewerProfile: viewerProfile,
                    componentFilters: systemComponentSpans,
                    graphicalAttributeSpecifier: SystemGraphicalAttributeSpecifier(
                        beatWidth: beatWidth,
                        sizeSpecifier: StaffTypeSizeSpecifier(
                            staffSpaceHeight: staffSpaceHeight,
                            scale: scale
                        )
                    )
                )
            )
        }
    }
}

