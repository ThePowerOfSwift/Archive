//
//  ClefStaffBass.swift
//  DNM
//
//  Created by James Bean on 1/10/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import QuartzCore

public class ClefStaffBass: ClefStaff {
    
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
        let xΔ: CGFloat = 0.5 * g
        let yΔ: CGFloat = 0.4 * g
        let yRef: CGFloat = extenderHeight + g
        for var i = -1; i < 2; i += 2 {
            let dot = ClefOrnamentDot()
            dot.x = xΔ
            dot.y = yRef + CGFloat(i) * yΔ
            dot.width = 0.382 * g
            dot.color = color
            dot.build()
            components.append(dot)
        }
    }
    
    internal override func getMiddleCPosition() -> CGFloat {
        var middleCPosition = -g
        adJustMiddleCPositionForTransposition(&middleCPosition)
        return middleCPosition
    }
}