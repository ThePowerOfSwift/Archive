//
//  TrebleClef.swift
//  StaffClef
//
//  Created by James Bean on 6/13/16.
//
//

import QuartzCore
import PathTools
import Color

public final class TrebleClef: CALayer, StaffClefView {
    
    public var ornamentAltitude: CGFloat {
        return 6 * CGFloat(staffSlotHeight) + extenderLength
    }
    
    private var circle: CircleClefOrnament {
        return CircleClefOrnament(
            point: CGPoint(x: 0, y: ornamentAltitude),
            radius: 0.8 * CGFloat(staffSlotHeight),
            lineWidth: lineWidth,
            color: Color.red.cgColor
        )
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
        components = [line, circle]
    }
}
