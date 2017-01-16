//
//  FlatUp.swift
//  Staff
//
//  Created by James Bean on 6/14/16.
//
//

import QuartzCore

public class FlatUp: Flat {
    
    public override var description: String { get { return "flatUp" } }
    
    internal override var column_up_height: CGFloat { get { return 2 * gS } }
    
    public override func createComponents() {
        addBody()
        addColumnUp()
        addColumnDown()
        addArrowUp()
    }
    
    internal func addArrowUp() {
        // add arrow
        arrow_left_up = ComponentArrow(
            staffSlotHeight: staffSlotHeight,
            scale: scale,
            point: CGPoint(x: 0, y: yRef - column_up_height),
            direction: .up
        )
        components.append(arrow_left_up!)
        arrow_left_up!.column = column_left_up
        arrow_left_up!.alignment = .left
    }
}
