//
//  BeamGroupViewModel.swift
//  DNM_iOS
//
//  Created by James Bean on 12/19/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import QuartzCore
import DNMModel

/**
ViewModel of BeamGroup, holds information re: graphical attributes of a BeamGroup
*/
public struct BeamGroupViewModel {
    
    /// The model of the rhythm to be graphically represented by the BeamGroup
    public var model: DurationNode

    // MARK: - Position
    public let origin: CGPoint
    
    // MARK: - Size
    public let staffSpaceHeight: StaffSpaceHeight
    public let scale: Scale
    public var scaledStaffHeight: StaffSpaceHeight { return staffSpaceHeight * scale }

    public let beatWidth: BeatWidth
    
    // MARK: - Orientation
    public let stemDirection: StemDirection
    
    // MARK: - Render settings
    public let showsMetrics: Bool
    public let showsNumerics: Bool
    
    /**
    Create a BeamGroupViewModel with a DurationNode model

    - parameter model: Model of rhythm to be represented by a BeamGroup

    - returns: BeamGroupViewModel
    */
    public init(
        model: DurationNode,
        graphicalAttributeSpecifier: BeamGroupGraphicalAttributeSpecifier = BeamGroupGraphicalAttributeSpecifier()
    )
    {
        self.model = model
        self.origin = graphicalAttributeSpecifier.origin
        self.beatWidth = graphicalAttributeSpecifier.beatWidth
        self.staffSpaceHeight = graphicalAttributeSpecifier.staffSpaceHeight
        self.scale = graphicalAttributeSpecifier.scale
        self.stemDirection = graphicalAttributeSpecifier.stemDirection
        self.showsMetrics = model.isMetrical
        self.showsNumerics = model.isNumerical
    }
}