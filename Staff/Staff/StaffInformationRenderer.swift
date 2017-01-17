//
//  StaffInformationRenderer.swift
//  Staff
//
//  Created by James Bean on 1/11/17.
//
//

import QuartzCore
import Color
import Pitch
import PitchSpellingTools
import GraphicsTools

public struct StaffInformationRenderer: Renderer {
    
    private let ledgerLinesRenderDelegate: LedgerLineRenderDelegate?
    let model: StaffModel

    public init(
        model: StaffModel,
        ledgerLinesRenderDelegate: LedgerLineRenderDelegate? = nil)
    {
        self.model = model
        self.ledgerLinesRenderDelegate = ledgerLinesRenderDelegate
    }
    
    public func render(
        in context: CALayer,
        with configuration: StaffInformationConfiguration
    )
    {
        // TODO: Conform model to sequence // collection
        for (position, points) in model.points {
            for point in points {
                
                let (above, below) = point.ledgerLines(model.clef)
                delegateLedgerLineRendering(at: position, above: above, below: below)
            }
        }
    }
    
    private func delegateLedgerLineRendering(at position: Double, above: Int, below: Int) {
        ledgerLinesRenderDelegate?.addLedgerLines(at: position, above: above, below: below)
    }
}
