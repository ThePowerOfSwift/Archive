//
//  ClefStaff.swift
//  DNM
//
//  Created by James Bean on 1/10/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import UIKit

// TODO: change g to StaffSpaceHeight
public class ClefStaff: Clef {
    
    // Size
    public var g: CGFloat = 0
    public var s: CGFloat = 1
    public var gS: CGFloat { get { return g * s } }
    
    public override var lineWidth: CGFloat { get { return 0.1236 * gS } }
    public var graphHeight: CGFloat { get { return 4 * gS } }
    public var extenderHeight: CGFloat { get { return 0.5 * gS } }
    public override var height: CGFloat { get { return graphHeight + (2 * extenderHeight) } }
    
    /// Transposition of Clef in Octaves (1 = 8va, 2 = 15va, -1 = 8vb, etc)
    public var transposition: Int = 0
    
    /// Graphical position of middleC in the score of this ClefStaff
    public var middleCPosition: CGFloat { get { return getMiddleCPosition() } }
    
    public class func with(type: ClefStaffType,
        origin: CGPoint = CGPointZero,
        sizeSpecifier: StaffTypeSizeSpecifier = StaffTypeSizeSpecifier(),
        transposition: Int = 0
    ) -> ClefStaff
    {
        let classType: ClefStaff.Type
        switch type {
        case .Treble: classType = ClefStaffTreble.self
        case .Alto: classType = ClefStaffAlto.self
        case .Tenor: classType = ClefStaffTenor.self
        case .Bass: classType = ClefStaffBass.self
        }
        return classType.init(
            origin: origin,
            sizeSpecifier: sizeSpecifier,
            transposition: transposition
        )
    }
    
    public class func withType(type: ClefStaffType) -> ClefStaff? {
        switch type {
        case .Treble: return ClefStaffTreble()
        case .Bass: return ClefStaffBass()
        case .Alto: return ClefStaffAlto()
        case .Tenor: return ClefStaffTenor()
        }
    }
    
    public class func withType(type: String,
        transposition: Int = 0,
        x: CGFloat,
        top: CGFloat,
        g: CGFloat,
        s: CGFloat = 1
    ) -> ClefStaff?
    {
        if let clefType = ClefStaffType(rawValue: type) {
            return ClefStaff.with(clefType,
                origin: CGPoint(x: x, y: top),
                sizeSpecifier: StaffTypeSizeSpecifier(
                    staffSpaceHeight: g,
                    scale: s
                ),
                transposition: transposition
            )
        }
        return nil
    }
    
    
    /*
    // take in origin, size specifier
    public class func withType(type: ClefStaffType,
        transposition: Int = 0, x: CGFloat, top: CGFloat, g: CGFloat, s: CGFloat = 1) -> ClefStaff?
    {
        return ClefStaff.with(type,
            origin: CGPoint(x: x, y: top),
            sizeSpecifier: StaffTypeSizeSpecifier(
                staffSpaceHeight: g,
                scale: s
            ),
            transposition: transposition
        )
    }
    */
    
    public required init(
        origin: CGPoint = CGPointZero,
        sizeSpecifier: StaffTypeSizeSpecifier = StaffTypeSizeSpecifier(),
        transposition: Int = 0
    )
    {
        super.init(origin: origin)
        self.g = sizeSpecifier.staffSpaceHeight
        self.s = sizeSpecifier.scale
        self.transposition = transposition
        build()
    }

    /*
    public init(x: CGFloat, top: CGFloat, g: CGFloat, s: CGFloat = 1) {
        super.init()
        self.x = x
        self.top = top
        self.g = g
        self.s = s
        build()
    }
    */
    
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    internal func getMiddleCPosition() -> CGFloat {
        // override
        return 0
    }
    
    internal func adJustMiddleCPositionForTransposition(inout middleCPosition: CGFloat) {
        middleCPosition += 3.5 * g * CGFloat(transposition)
    }
    
    internal override func addComponents() {
        // transposition things here
        addGraphLine()
        addOrnament()
        if transposition != 0 { addTranspositionLabel() }
    }
    
    // make own class, make nice when time available
    internal func addTranspositionLabel() {
        
        func descriptorFromTransposition(transposition: Int) -> String {
            switch abs(transposition) {
            case 1: return "8"
            case 2: return "15"
            case 3: return "22"
            default: return "0"
            }
        }
        
        let pad = 0.236 * g
        let h = 1.236 * g
        let top = transposition > 0 ? -(h + pad) : height + pad
        let test_8 = TextLayerConstrainedByHeight(
            text: descriptorFromTransposition(transposition),
            x: 0,
            top: top,
            height: h,
            alignment: .Center,
            fontName: "AvenirNext-Regular"
        )
        test_8.foregroundColor = UIColor.grayColor().CGColor
        addSublayer(test_8)
        
    }
    
    internal func addOrnament() {
        // override
    }
}