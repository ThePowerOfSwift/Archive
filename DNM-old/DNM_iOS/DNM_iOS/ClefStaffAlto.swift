//
//  ClefStaffAlto.swift
//  DNM
//
//  Created by James Bean on 1/10/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import QuartzCore

public class ClefStaffAlto: ClefStaff {
    
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    public required init(
        origin: CGPoint = CGPointZero,
        sizeSpecifier: StaffTypeSizeSpecifier = StaffTypeSizeSpecifier(),
        transposition: Int = 0
    )
    {
        super.init(origin: origin, sizeSpecifier: sizeSpecifier, transposition: transposition)
    }
    
    internal override func addOrnament() {
        let diamond = ClefOrnamentDiamond()
        diamond.x = 0
        diamond.y = 2 * g + extenderHeight
        diamond.width = 1 * g
        diamond.lineWidth = lineWidth
        diamond.color = color
        diamond.build()
        components.append(diamond)
    }
    
    internal override func getMiddleCPosition() -> CGFloat {
        var middleCPosition = 2 * g
        adJustMiddleCPositionForTransposition(&middleCPosition)
        return middleCPosition
    }
}
