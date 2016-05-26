//
//  ClefStaffTreble.swift
//  DNM
//
//  Created by James Bean on 1/10/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import QuartzCore

public class ClefStaffTreble: ClefStaff {
    
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }

    public required init(origin: CGPoint, sizeSpecifier: StaffTypeSizeSpecifier) {
        super.init(origin: origin, sizeSpecifier: sizeSpecifier)
    }

    public required init(
        origin: CGPoint = CGPointZero,
        sizeSpecifier: StaffTypeSizeSpecifier = StaffTypeSizeSpecifier(),
        transposition: Int = 0
    )
    {
        super.init(origin: origin, sizeSpecifier: sizeSpecifier, transposition: transposition)
    }
    
    internal override func addOrnament() {
        let circle = ClefOrnament.withType(.Circle,
            x: 0,
            y: 3 * gS + extenderHeight,
            width: 0.75 * gS
        )!
        circle.lineWidth = lineWidth
        circle.strokeColor = color
        components.append(circle)
    }
    
    internal override func getMiddleCPosition() -> CGFloat {
        var middleCPosition = 5 * g
        adJustMiddleCPositionForTransposition(&middleCPosition)
        
        return middleCPosition
    }
}
