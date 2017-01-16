//
//  NaturalUp.swift
//  Staff
//
//  Created by James Bean on 6/14/16.
//
//

import QuartzCore

public class NaturalUp: Natural {
    
    public override var description: String { get { return "naturalUp" } }
    
    internal override var column_left_up_height: CGFloat { get { return 2 * gS } }
    
    internal override var height: CGFloat {
        get { return column_left_up_height + column_right_down_height + 0.5 * arrowHeight }
    }
    
    internal override var xRef: CGFloat { get { return 0.5 * width } }
    internal override var yRef: CGFloat {
        get { return column_left_up_height + 0.5 * arrowHeight }
    }
    
    public override func createComponents() {
        addBody()
        addLeftColumnUp()
        addLeftColumnDown()
        addRightColumnDown()
        addRightColumnUp()
        addArrow()
    }
    
    internal func addArrow() {
        arrow_left_up = ComponentArrow(
            staffSlotHeight: staffSlotHeight,
            scale: scale,
            point: CGPoint(x: xRef - 0.5 * midWidth, y: yRef - column_left_up_height),
            direction: .up
        )
        components.append(arrow_left_up!)
        arrow_left_up!.column = column_left_up
        arrow_left_up!.alignment = .left
    }
}
