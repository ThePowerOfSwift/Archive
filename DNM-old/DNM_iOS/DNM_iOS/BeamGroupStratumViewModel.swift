//
//  BeamGroupStratumViewModel.swift
//  DNM_iOS
//
//  Created by James Bean on 12/19/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import QuartzCore
import DNMModel

/**
ViewModel of BeamGroupStratum, holds information re: graphical attributes of a BeamGroup
*/
public struct BeamGroupStratumViewModel {
    
    // todo: this will become a struct (rather than a typealias)
    public var model: DurationNodeStratum
    
    // MARK: - Position
    public let origin: CGPoint
    
    // MARK: - Size
    public let staffSpaceHeight: StaffSpaceHeight
    public let scale: Scale
    
    public let beatWidth: BeatWidth
    
    // MARK: - Orientation
    public let stemDirection: StemDirection
    
    // MARK: - Render settings
    public let showsMetrics: Bool
    public let showsNumerics: Bool
    
    /**
    Create a BeamGroupStratumViewModel with a DurationNodeStratum model and
    BeamGroupGraphicalAttributeSpecifier

    - parameter model:                       DurationNodeStratum
    - parameter graphicalAttributeSpecifier: BeamGroupGraphicalAttributeSpecifier

    - returns: BeamGroupStratumViewModel
    */
    public init(
        model: DurationNodeStratum,
        graphicalAttributeSpecifier: BeamGroupGraphicalAttributeSpecifier = BeamGroupGraphicalAttributeSpecifier()
    )
    {
        self.model = model
        self.origin = graphicalAttributeSpecifier.origin
        self.beatWidth = graphicalAttributeSpecifier.beatWidth
        self.staffSpaceHeight = graphicalAttributeSpecifier.staffSpaceHeight
        self.scale = graphicalAttributeSpecifier.scale
        self.stemDirection = graphicalAttributeSpecifier.stemDirection
        self.showsMetrics = graphicalAttributeSpecifier.showsMetrics
        self.showsNumerics = graphicalAttributeSpecifier.showsNumerics
    }
    
    public func makeBeamGroupViewModels() -> [BeamGroupViewModel] {
        return model.map {
            let graphicalAttr = copyGraphicalAttributesWith(CGPoint(x: xValueFor($0), y: 0))
            return BeamGroupViewModel(model: $0, graphicalAttributeSpecifier: graphicalAttr)
        }
    }
    
    public func copyGraphicalAttributesWith(newOrigin: CGPoint)
        -> BeamGroupGraphicalAttributeSpecifier
    {
        
        let graphicalAttributeSpecifier = BeamGroupGraphicalAttributeSpecifier(
            origin: newOrigin,
            stemDirection: stemDirection,
            beatWidth: beatWidth,
            sizeSpecifier: StaffTypeSizeSpecifier(
                staffSpaceHeight: staffSpaceHeight,
                scale: scale
            ),
            temporalRenderAttributeSpecifier: BeamGroupTemporalRenderAttributeSpecifier(
                showMetrics: showsMetrics,
                showNumerics: showsNumerics
            )
        )
        return graphicalAttributeSpecifier
    }
    
    private func xValueFor(durationNode: DurationNode) -> CGFloat {
        let offsetDuration = (
            durationNode.durationInterval.startDuration - model.systemDurationOffset
        )
        return origin.x + offsetDuration.width(beatWidth: beatWidth)
    }
}