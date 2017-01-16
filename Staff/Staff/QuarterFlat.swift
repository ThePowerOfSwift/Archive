//
//  QuarterFlat.swift
//  Staff
//
//  Created by James Bean on 6/14/16.
//
//

import QuartzCore

public class QuarterFlat: Accidental {
    
    public override var description: String { get { return "quarterFlat" } }
    
    public var column_up: ComponentColumn?
    public var column_down: ComponentColumn?
    
    internal var column_up_height: CGFloat { get { return 1.618 * gS } }
    internal var column_down_height: CGFloat { get { return 0.75 * gS } }
    
    internal override var height: CGFloat {
        get { return column_up_height + column_down_height }
    }
    
    internal override var width: CGFloat { get { return midWidth } }
    internal override var xRef: CGFloat { get { return 0.5 * midWidth } }
    internal override var yRef: CGFloat { get { return column_up_height } }
    
    public override func createComponents() {
        addBody()
        addColumnUp()
        addColumnDown()
    }
    
    internal func addBody() {
        body = ComponentBodyQuarterFlat(
            staffSlotHeight: staffSlotHeight,
            scale: scale,
            point: CGPoint(x: xRef - 0.5 * thinLineWidth, y: yRef)
        )
        components.append(body!)
    }
    
    internal func addColumnUp() {
        column_right_up = ComponentColumn(
            staffSlotHeight: staffSlotHeight,
            scale: scale,
            x: width,
            y_internal: yRef,
            y_external: yRef - column_up_height
        )
        column_right_up!.alignment = .right
        components.append(column_right_up!)
    }
    
    internal func addColumnDown() {
        column_right_down = ComponentColumn(
            staffSlotHeight: staffSlotHeight,
            scale: scale,
            x: width,
            y_internal: yRef,
            y_external: yRef + column_down_height
        )
        components.append(column_right_down!)
        column_right_down!.alignment = .right
    }
}
