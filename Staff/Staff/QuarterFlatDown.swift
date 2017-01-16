//
//  QuarterFlatDown.swift
//  Staff
//
//  Created by James Bean on 6/14/16.
//
//

import QuartzCore

public class QuarterFlatDown: QuarterFlat {
    
    public override var description: String { get { return "quarterFlatDown" } }
    
    public var arrow_down: ComponentArrow?
    
    internal override var column_down_height: CGFloat { get { return 1.5 * gS } }
    
    public override func createComponents() {
        addBody()
        addColumnUp()
        addColumnDown()
        addArrowDown()
    }
    
    internal func addArrowDown() {
        arrow_right_down = ComponentArrow(
            staffSlotHeight: staffSlotHeight,
            scale: scale,
            point: CGPoint(x: width, y: yRef + column_down_height),
            direction: .down
        )
        components.append(arrow_right_down!)
        arrow_right_down!.column = column_right_down
        arrow_right_down!.alignment = .right
    }
}
