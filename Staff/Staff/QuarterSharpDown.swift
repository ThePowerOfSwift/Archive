//
//  QuarterSharpDown.swift
//  Staff
//
//  Created by James Bean on 6/14/16.
//
//

import QuartzCore

public class QuarterSharpDown: QuarterSharp {
    
    public override var description: String { get { return "quarterSharpDown" } }
    
    public override var column_down_height: CGFloat { get { return 2 * gS } }
    
    internal override var height: CGFloat {
        get { return column_up_height + column_down_height + 0.5 * arrowHeight }
    }
    
    internal override var width: CGFloat { get { return thickLineLength } }
    
    internal override var yRef: CGFloat { get { return column_up_height } }
    
    public override func createComponents() {
        addBody()
        addColumnUp()
        addColumnDown()
        addArrow()
    }
    
    internal func addArrow() {
        arrow_center_down = ComponentArrow(
            staffSlotHeight: staffSlotHeight,
            scale: scale,
            point: CGPoint(x: xRef, y: yRef + column_down_height),
            direction: .down
        )
        components.append(arrow_center_down!)
        arrow_center_down!.column = column_center_down
        arrow_center_down!.alignment = .center
    }
}

