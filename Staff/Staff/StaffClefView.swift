//
//  StaffClefView.swift
//  Staff
//
//  Created by James Bean on 1/12/17.
//
//

import QuartzCore
import GraphicsTools
import Color

public protocol StaffClefView: StaffSlotScaling, CompositeShapeType {
    
    var x: CGFloat { get }
    var staffTop: CGFloat { get }
    var lineWidth: CGFloat { get }
    var staffSlotHeight: StaffSlot { get }
    var extenderLength: CGFloat { get }

    init(x: CGFloat, staffTop: CGFloat, staffSlotHeight: StaffSlot)
}

extension StaffClefView {
    
    public var extenderLength: CGFloat {
        return 1 * CGFloat(staffSlotHeight)
    }
    
    public var lineWidth: CGFloat {
        return 0.15 * CGFloat(staffSlotHeight)
    }
    
    public var line: LineClefComponent {
        return LineClefComponent(
            height: frame.height,
            lineWidth: lineWidth,
            color: Color.red.cgColor
        )
    }
    
    public func makeFrame() -> CGRect {
        return CGRect(
            x: x,
            y: staffTop - extenderLength,
            width: 0,
            height: 8 * CGFloat(staffSlotHeight) + 2 * extenderLength
        )
    }
}


extension StaffClef.Kind {
    
    /// - returns: The `Type` of a view representation of a given `StaffClef.Kind`.
    var view: StaffClefView.Type {
        switch self {
        case .bass:
            return TrebleClef.self
        case .tenor:
            return TenorClef.self
        case .alto:
            return AltoClef.self
        case .treble:
            return TrebleClef.self
        }
    }
}
