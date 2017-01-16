//
//  StaffStructureConfiguration.swift
//  Staff
//
//  Created by James Bean on 1/12/17.
//
//

import QuartzCore
import Color

/// - TODO: Consider using `ColorMode` in here
public struct StaffStructureConfiguration: StaffSlotScaling {
    
    public let staffSlotHeight: StaffSlot
    public let linesColor: Color
    
    var ledgerLineWidth: Double {
        return 0.175 * Double(staffSlotHeight)
    }
    
    var lineWidth: Double {
        return 0.1 * Double(staffSlotHeight)
    }
    
    var ledgerLineLength: Double {
        return 3 * Double(staffSlotHeight)
    }
    
    public init(
        staffSlotHeight: StaffSlot = 12,
        linesColor: Color = Color.init(gray: 0.5, alpha: 1)
    )
    {
        self.staffSlotHeight = staffSlotHeight
        self.linesColor = linesColor
    }
}
