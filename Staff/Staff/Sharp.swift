//
//  Sharp.swift
//  Staff
//
//  Created by James Bean on 6/14/16.
//
//

import QuartzCore

public class Sharp: Accidental, SharpType {
    
    public override var description: String { get { return "sharp" } }
    
    internal var column_left_up_height: CGFloat { get { return 0.95 * gS } }
    internal var column_left_down_height: CGFloat { get { return 1.05 * gS } }
    internal var column_right_up_height: CGFloat { get { return 1.05 * gS } }
    internal var column_right_down_height: CGFloat { get { return 0.95 * gS } }
    
    
    internal override var height: CGFloat {
        get { return column_right_up_height + column_left_down_height }
    }
    
    internal override var width: CGFloat { get { return thickLineLength } }
    
    internal override var xRef: CGFloat { get { return 0.5 * width } }
    internal override var yRef: CGFloat { get { return 0.5 * height } }
    
    public override func createComponents() {
        addBody()
        addColumnLeftUp()
        addColumnLeftDown()
        addColumnRightUp()
        addColumnRightDown()
    }
    
    internal func addBody() {
        body = ComponentBodySharp(staffSlotHeight: staffSlotHeight, scale: scale, point: CGPoint(x: xRef, y: yRef))
        components.append(body!)
    }
    
    internal func addColumnLeftUp() {
        column_left_up = ComponentColumn(
            staffSlotHeight: staffSlotHeight,
            scale: scale,
            x: xRef - 0.5 * midWidth,
            y_internal: yRef,
            y_external: yRef - column_left_up_height
        )
        components.append(column_left_up!)
        column_left_up!.alignment = .left
    }
    
    internal func addColumnLeftDown() {
        column_left_down = ComponentColumn(
            staffSlotHeight: staffSlotHeight,
            scale: scale,
            x: xRef - 0.5 * midWidth,
            y_internal: yRef,
            y_external: yRef + column_left_down_height
        )
        components.append(column_left_down!)
        column_left_down!.alignment = .left
    }
    
    internal func addColumnRightUp() {
        column_right_up = ComponentColumn(
            staffSlotHeight: staffSlotHeight,
            scale: scale,
            x: xRef + 0.5 * midWidth,
            y_internal: yRef,
            y_external: yRef - column_right_up_height
        )
        components.append(column_right_up!)
        column_right_up!.alignment = .right
    }
    
    internal func addColumnRightDown() {
        column_right_down = ComponentColumn(
            staffSlotHeight: staffSlotHeight,
            scale: scale,
            x: xRef + 0.5 * midWidth,
            y_internal: yRef,
            y_external: yRef + column_right_down_height
        )
        components.append(column_right_down!)
        column_right_down!.alignment = .right
    }
}

