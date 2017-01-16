
//
//  .swift
//  DNM_iOS
//
//  Created by James Bean on 8/18/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import QuartzCore
import GraphicsTools

import Color

// TODO: Make protocol
// TODO: Utilize CALayer.anchorPoint property
public class Accidental: CALayer, CompositeShapeType, StaffSlotScaling {
    
    /**
     Position of the .
     
     > `y` value generally being on a staff line, or equidistance between two.
     >
     > `x` values of a column of accidentals are aligned.
    */
    public let point: CGPoint
    
    /// Graphical height of a single Guidonian staff space
    public let staffSlotHeight: StaffSlot
    
    /// Scale.
    public let scale: CGFloat
    
    public var gS: CGFloat {
        return CGFloat(staffSlotHeight) * scale
    }
    
    internal var xRef: CGFloat { fatalError() }
    internal var yRef: CGFloat { fatalError() }
    
    internal var left: CGFloat { fatalError() }
    internal var top: CGFloat  { fatalError() }
    internal var width: CGFloat  { fatalError() }
    internal var height: CGFloat  { fatalError() }
    
    public var boundingWidth: CGFloat? { get { return getBoundingWidth() } }
    
    // for sharp types
    public var midWidth: CGFloat { get { return 0.575 * gS } }
    public var flankWidth: CGFloat { get { return 0.15 * gS } }

    public var thinLineWidth: CGFloat { get { return 0.0875 * gS } }
    
    // arrow having types
    public var arrowHeight: CGFloat { get { return 0.618 * gS } }
    
    public var column: Int?
    
    public var components: [CALayer] = []
    
    public var body: ComponentBody?
    
    public var column_left_up: ComponentColumn?
    public var column_left_down: ComponentColumn?
    
    public var column_center_up: ComponentColumn?
    public var column_center_down: ComponentColumn?
    
    public var column_right_up: ComponentColumn?
    public var column_right_down: ComponentColumn?
    
    public var arrow_left_up: ComponentArrow?
    public var arrow_left_down: ComponentArrow?
    
    public var arrow_center_up: ComponentArrow?
    public var arrow_center_down: ComponentArrow?
    
    public var arrow_right_up: ComponentArrow?
    public var arrow_right_down: ComponentArrow?
    
    public var color: Color = Color(gray: 0.85, alpha: 1) {
        
        didSet {
            
            print("color did set: \(color)")
            
            self.components
                .flatMap { $0 as? CAShapeLayer }
                .forEach { $0.fillColor = color.cgColor }
        }
    }

    public required init(point: CGPoint, staffSlotHeight: StaffSlot, scale: CGFloat) {
        self.point = point
        self.staffSlotHeight = staffSlotHeight
        self.scale = scale
        super.init()
        build()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    public func createComponents() {
        
    }
    
    public func commitComponents() {
        self.components
            .flatMap { $0 as? CAShapeLayer }
            .forEach { $0.fillColor = color.cgColor }
    }
    
    public func makeFrame() -> CGRect {
        let left = point.x - xRef
        let top = point.y - yRef
        return CGRect(x: left, y: top, width: width, height: height)
    }
    
    private func setFrame() {
        let left = point.x - xRef
        let top = point.y - yRef
        frame = CGRect(x: left, y: top, width: width, height: height)
    }
    
    private func getHeight() -> CGFloat {
        let minY: CGFloat = getMinY(components)
        let maxY: CGFloat = getMaxY(components)
        let height: CGFloat = -minY + maxY
        return height
    }
    
    internal func getBoundingWidth() -> CGFloat? {
        if components.count == 0 { return nil }
        var minX: CGFloat?
        var maxX: CGFloat?
        for component in components {
            if minX == nil { minX = component.frame.minX }
            else if component.frame.minX < minX! { minX = component.frame.minX }
            if maxX == nil { maxX = component.frame.maxX }
            else if component.frame.maxX > maxX! { maxX = component.frame.maxX }
        }
        return maxX! - minX!
    }
    
    // abstract these for more global usage with CALayers
    internal func getMinY(_ layers: [CALayer]) -> CGFloat {
        var newLayers: [CALayer] = layers
        newLayers.sort { $0.frame.minY < $1.frame.minY }
        return newLayers.first!.frame.minY
    }
    
    internal func getMaxY(_ layers: [CALayer]) -> CGFloat {
        var newLayers: [CALayer] = layers
        newLayers.sort { $0.frame.maxX > $1.frame.maxX }
        return newLayers.first!.frame.maxY
    }
}

extension Accidental {
    
    public static func makeAccidental(
        withKind kind: AccidentalKind,
        point: CGPoint,
        staffSlotHeight: StaffSlot,
        scale: CGFloat = 1
    ) -> Accidental
    {
        var classType: Accidental.Type {
            switch kind {
            case .natural: return Natural.self
            case .naturalUp: return NaturalUp.self
            case .naturalDown: return NaturalDown.self
            case .sharp: return Sharp.self
            case .sharpUp: return SharpUp.self
            case .sharpDown: return SharpDown.self
            case .flat: return Flat.self
            case .flatUp: return FlatUp.self
            case .flatDown: return FlatDown.self
            case .quarterSharp: return QuarterSharp.self
            case .quarterSharpUp: return QuarterSharpUp.self
            case .quarterSharpDown: return QuarterSharpDown.self
            case .quarterFlat: return QuarterFlat.self
            case .quarterFlatUp: return QuarterFlatUp.self
            case .quarterFlatDown: return QuarterFlatDown.self
            }
        }
        return classType.init(point: point, staffSlotHeight: staffSlotHeight, scale: scale)
    }
    
    public static func makeAccidental(
        coarse: Float,
        fine: Float,
        point: CGPoint,
        staffSlotHeight: StaffSlot,
        scale: CGFloat = 1
    ) -> Accidental?
    {
        guard let kind = AccidentalKind(coarse: coarse, fine: fine) else { return nil }
        return makeAccidental(
            withKind: kind,
            point: point,
            staffSlotHeight: staffSlotHeight,
            scale: scale
        )
    }
}
