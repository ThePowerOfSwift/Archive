//
//  BeamGroupGraphicalAttributeSpecifier.swift
//  DNM_iOS
//
//  Created by James Bean on 12/19/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import QuartzCore

/**
 Holds attributes defining the GraphicalAttributes of aBeamGroup
 */
public struct BeamGroupGraphicalAttributeSpecifier {
 
    // MARK: - Size
    public let staffSpaceHeight: StaffSpaceHeight
    public let scale: Scale
    public let beatWidth: BeatWidth // 110
    
    // MARK: - Position
    public let origin: CGPoint // CGPointZero
    
    // MARK: - TemporalRenderAttributes
    public let showsMetrics: Bool
    public let showsNumerics: Bool
    
    /// StemDirection of BeamGroup
    public let stemDirection: StemDirection
    
    /**
    Create a BeamGroupGraphicalAttributeSpecifier

    - parameter origin:                           Origin of BeamGroup
    - parameter beatWidth:                        Graphical width of a single 8th-note
    - parameter sizeSpecifier:                    StaffType size attributes
    - parameter temporalRenderAttributeSpecifier: TemporalRender attributes

    - returns: BeamGroupGraphicalAttributeSpecifier
    */
    public init(
        origin: CGPoint = CGPointZero,
        stemDirection: StemDirection = .Down,
        beatWidth: BeatWidth = 110,
        sizeSpecifier: StaffTypeSizeSpecifier = StaffTypeSizeSpecifier(),
        temporalRenderAttributeSpecifier: BeamGroupTemporalRenderAttributeSpecifier = BeamGroupTemporalRenderAttributeSpecifier()
    )
    {
        self.origin = origin
        self.stemDirection = stemDirection
        self.beatWidth = beatWidth
        self.staffSpaceHeight = sizeSpecifier.staffSpaceHeight
        self.scale = sizeSpecifier.scale
        self.showsMetrics = temporalRenderAttributeSpecifier.showMetrics
        self.showsNumerics = temporalRenderAttributeSpecifier.showNumerics
    }
}