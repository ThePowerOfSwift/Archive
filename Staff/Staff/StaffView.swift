//
//  StaffView.swift
//  Staff
//
//  Created by James Bean on 1/11/17.
//
//

import PitchSpellingTools
import Color
import QuartzCore
import GraphicsTools
import Plot

public final class StaffView: CALayer, PlotView/*, StaffSlotScaling*/ {
    
    public let model: StaffModel
    
    public let verticalAxis: StaffClef
    public let horizontalAxis = LinearAxis<Double>()
    
    public let concreteVerticalPosition: (StaffSlot) -> Double = { _ in fatalError() }
    public let concreteHorizontalPosition: (Double) -> Double = { _ in fatalError() }
    
    public let structure = CALayer()
    public let information = CALayer()
    
    public var informationRenderer: StaffInformationRenderer
    public var structureRenderer: StaffStructureRenderer
    
    // TODO: Expose dimensions
    
    public init(clef: StaffClef) {
        self.model = StaffModel(clef: clef)

        self.verticalAxis = StaffClef(clef.kind)
        self.structureRenderer = StaffStructureRenderer(clef: clef.kind)
        
        let sp = SpelledPitch(60, PitchSpelling(.c))
        self.informationRenderer = StaffInformationRenderer(pitch: sp)
        
        super.init()
        build()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TEST:
    public func addEvent(pitch: SpelledPitch, at x: CGFloat) {
        
    }
    
    public func build() {
        
        let structureConfig = StaffStructureConfiguration(
            staffSlotHeight: 12,
            linesColor: Color(gray: 1, alpha: 1)
        )
        
        let infoConfig = StaffInformationConfiguration(noteheadColor: Color.red)
        
        structureRenderer.startLines(at: 0)
        structureRenderer.stopLines(at: 25)
        structureRenderer.startLines(at: 50)
        structureRenderer.stopLines(at: 175)
        structureRenderer.startLines(at: 350)
        structureRenderer.stopLines(at: 500)
        structureRenderer.addLedgerLinesAbove(at: 30, amount: 3)
        structureRenderer.addLedgerLinesBelow(at: 60, amount: 3)
        
        structureRenderer.render(in: self, with: structureConfig)
        informationRenderer.render(in: self, with: infoConfig)
        
    }
}
