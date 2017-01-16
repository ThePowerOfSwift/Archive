//
//  BassClef.swift
//  StaffClef
//
//  Created by James Bean on 6/13/16.
//
//

import QuartzCore
import PathTools
import GraphicsTools
import Color

public final class BassClef: CALayer, StaffClefView {
    
    public var ornamentAltitude: CGFloat {
        return 1 * CGFloat(staffSlotHeight) + extenderLength
    }
    
    private var dots: [DotClefOrnament] {
        
        // Create a dot above and below (by 0.8 staff slots) the `ornamentAltitude`
        return [-1, 1].map { sign in
            DotClefOrnament(
                point: CGPoint(
                    x: 0.5 * CGFloat(staffSlotHeight),
                    y: ornamentAltitude + CGFloat(0.8) * CGFloat(sign)
                ),
                radius: 0.175 * CGFloat(staffSlotHeight),
                color: Color.red.cgColor
            )
        }
    }

    /// Components that need to built and added
    public var components: [CALayer] = []
    public let x: CGFloat
    public let staffTop: CGFloat
    public let staffSlotHeight: StaffSlot
    
    public init(x: CGFloat, staffTop: CGFloat, staffSlotHeight: StaffSlot) {
        self.x = x
        self.staffTop = staffTop
        self.staffSlotHeight = staffSlotHeight
        super.init()
        build()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func createComponents() {
        components = [line] + dots
    }
}
