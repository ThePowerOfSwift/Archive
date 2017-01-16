//
//  FlatDown.swift
//  Staff
//
//  Created by James Bean on 6/14/16.
//
//

import QuartzCore

public class FlatDown: Flat {
    
    public override var description: String { get { return "flatDown" } }
    
    internal override var column_down_height: CGFloat { get { return 1.5 * gS } }
    
    public override func createComponents() {
        addBody()
        addColumnUp()
        addColumnDown()
        addArrowDown()
    }
    
    internal func addArrowDown() {
        arrow_left_down = ComponentArrow(
            staffSlotHeight: staffSlotHeight,
            scale: scale,
            point: CGPoint(x: 0, y: yRef + column_down_height),
            direction: .down
        )
        components.append(arrow_left_down!)
        arrow_left_down!.column = column_left_down
        arrow_left_down!.alignment = .left

    }
}
