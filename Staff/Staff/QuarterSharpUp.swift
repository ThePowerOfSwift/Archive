//
//  QuarterSharpUp.swift
//  Staff
//
//  Created by James Bean on 6/14/16.
//
//

import QuartzCore

public class QuarterSharpUp: QuarterSharp {
    
    public override var description: String { get { return "quarterSharpUp" } }
    
    public override var column_up_height: CGFloat { get { return  2 * gS } }
    
    internal override var height: CGFloat {
        get { return column_up_height + column_down_height + 0.5 * arrowHeight }
    }
    internal override var width: CGFloat { get { return thickLineLength } }
    
    internal override var yRef: CGFloat { get { return column_up_height + 0.5 * arrowHeight } }
    
    public override func createComponents() {
        addBody()
        addColumnUp()
        addColumnDown()
        addArrow()
    }
    
    internal func addArrow() {
        arrow_center_up = ComponentArrow(
            staffSlotHeight: staffSlotHeight,
            scale: scale,
            point: CGPoint(x: xRef, y: yRef - column_up_height),
            direction: .up
        )
        components.append(arrow_center_up!)
        arrow_center_up!.column = column_center_up
        arrow_center_up!.alignment = .center
    }
}
