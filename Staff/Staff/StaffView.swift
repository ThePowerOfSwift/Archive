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

public final class StaffView: CALayer, PlotView {
    
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
    
    public init(model: StaffModel) {
        self.model = model
        self.verticalAxis = model.clef
        self.structureRenderer = StaffStructureRenderer(model: model)
        self.informationRenderer = StaffInformationRenderer(model: model)
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
        
        print("model: \(model)")
        
        /*
        structureRenderer.startLines(at: 0)
        structureRenderer.stopLines(at: 25)
        structureRenderer.startLines(at: 50)
        structureRenderer.stopLines(at: 175)
        structureRenderer.startLines(at: 350)
        structureRenderer.stopLines(at: 500)
        structureRenderer.addLedgerLinesAbove(at: 30, amount: 3)
        structureRenderer.addLedgerLinesBelow(at: 60, amount: 3)
        */
        
        structureRenderer.render(in: self, with: structureConfig)
        informationRenderer.render(in: self, with: infoConfig)
        
    }
}
