//
//  StaffImplementationTests.swift
//  Plot
//
//  Created by James Bean on 1/10/17.
//
//

import XCTest
import GraphicsTools
import Plot

class StaffImplementationTests: XCTestCase {

    typealias Pitch = Float
    typealias StaffSlot = Int
    
    // slots:
    // ---- +4
    //      +3
    // ---- +2
    //      +1
    // ---- +0
    //      -1
    // ---- -2
    //      -3
    // ---- -4
    
    struct PitchContext {
        let x: Double
        let pitches: [Pitch]
        let articulations: [Any]
    }

    struct Clef: Axis {
        let coordinate: (Pitch) -> StaffSlot
    }
    
    struct StaffStructureConfiguration { }
    struct StaffInformationConfiguration { }
    
    struct StaffInformationRenderer: Renderer {
        
        typealias Configuration = StaffInformationConfiguration
        typealias GraphicalContext = CALayer
        
        func render<Context, Configuration> (
            in context: Context,
            with configuration: Configuration
        )
        {
            // something
        }
    }
    
    struct StaffStructureRenderer: Renderer {
        
        typealias Configuration = StaffStructureConfiguration
        typealias GraphicalContext = CALayer

        func startLines(at x: Double) { }
        func stopLines(at x: Double) { }
        func addLedgerLines(at x: Double, above: Int, below: Int) { }
        
        func render<Context, Configuration> (
            in context: Context,
            with configuration: Configuration
        )
        {
            // something
        }
    }
    
    struct StaffModel: PlotModel {
        typealias Entity = Pitch
    }
    
    typealias Beats = Int
    
    struct MusicSpacing: Axis {
        let coordinate: (Beats) -> Double
    }
    
    let defaultMusicSpacing: MusicSpacing = MusicSpacing(coordinate: { beats in Double(beats) })
    
    struct VerticalAxis: Axis {
        let coordinate: (Double) -> Double
    }
    
    struct Staff: PlotView {
        
        let model: StaffModel
        let verticalAxis: Clef
        let horizontalAxis: MusicSpacing
        let structure: CALayer
        let information: CALayer
        let structureRenderer: StaffStructureRenderer
        let informationRenderer: StaffInformationRenderer
        
        let concreteVerticalPosition: (StaffSlot) -> Double = { _ in return 0 }
        let concreteHorizontalPosition: (Double) -> Double = { _ in return 0 }
        
        init(model: StaffModel, verticalAxis: Clef, horizontalAxis: MusicSpacing) {
            self.model = model
            self.verticalAxis = verticalAxis
            self.horizontalAxis = horizontalAxis
            self.structure = CALayer()
            self.information = CALayer()
            self.structureRenderer = StaffStructureRenderer()
            self.informationRenderer = StaffInformationRenderer()
        }
    }
    
    struct TablatureModel: PlotModel {
        typealias Entity = Double
    }
    
    struct DefaultConfiguration { }
    
    struct DefaultRenderer: Renderer {
        
        typealias Configuration = DefaultConfiguration
        typealias GraphicalContext = CALayer
        
        func render<Context, Configuration> (
            in context: Context,
            with configuration: Configuration
        )
        {
            fatalError("Does not do anything")
        }
    }
    
    struct OneDimensionalTablature: PlotView {
        
        let model = TablatureModel()
        let verticalAxis = LinearAxis<Double>()
        let horizontalAxis = LinearAxis<Double>()
        let structure = CALayer()
        let information = CALayer()
        let structureRenderer = DefaultRenderer()
        let informationRenderer = DefaultRenderer()
        
        let concreteVerticalPosition: (Double) -> Double = { _ in 0 }
        let concreteHorizontalPosition: (Double) -> Double = { _ in 0 }
    }
    
    func testStaffImplementation() {
        let bassClef = Clef { _ in return 0 }
        let model = StaffModel()
        
        let staff  = Staff(
            model: model,
            verticalAxis: bassClef,
            horizontalAxis: defaultMusicSpacing
        )
    }
    
    func testTablatureImplementation() {
        let tablature = OneDimensionalTablature()
    }
}
