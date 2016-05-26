//
//  BeamGroupTemporalRenderAttributeSpecifier.swift
//  DNM_iOS
//
//  Created by James Bean on 12/19/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

/**
Holds attributes defining the TemporalRenderAttributes of a BeamGroup
*/
public struct BeamGroupTemporalRenderAttributeSpecifier {
    
    /// If BeamGroup should show beaming
    public var showMetrics: Bool
    
    /// If BeamGroup should show tuplet numerics (if necessary)
    public var showNumerics: Bool
    
    /**
    Create BeamGroupTemporalRenderAttributeSpecififer

    - parameter showMetrics:  If BeamGroup should show beaming
    - parameter showNumerics: If BeamGroup should show tuplet numerics (if necessary)

    - returns: BeamGroupTemporalRenderAttributeSpecifier
    */
    public init(showMetrics: Bool = true, showNumerics: Bool = true) {
        self.showMetrics = showMetrics
        self.showNumerics = showNumerics
    }
}