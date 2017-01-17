//
//  QuarterSharp.swift
//  Staff
//
//  Created by James Bean on 6/14/16.
//
//

import QuartzCore

public class QuarterSharp: Accidental, SharpType {
    
    public override var description: String { get { return "quarterSharp" } }
    
    public var column_up_height: CGFloat { get { return 1.236 * gS } }
    public var column_down_height: CGFloat { get { return 1.236 * gS } }
    
    internal override var height: CGFloat { get { return column_up_height + column_down_height } }
    internal override var width: CGFloat { get { return thickLineLength } }
    
    internal override var xRef: CGFloat { get { return 0.5 * width } }
    internal override var yRef: CGFloat { get { return 0.5 * height } }
    
    public override func createComponents() {
        addBody()
        addColumnUp()
        addColumnDown()
    }
    
    internal func addBody() {
        body = ComponentBodyQuarterSharp(
            staffSlotHeight: staffSlotHeight, scale: scale, point: CGPoint(x: xRef, y: yRef)
        )
        components.append(body!)
    }
    
    internal func addColumnUp() {
        column_center_up = ComponentColumn(
            staffSlotHeight: staffSlotHeight, scale: scale, x: xRef, y_internal: yRef, y_external: yRef - column_up_height
        )
        components.append(column_center_up!)
        column_center_up!.alignment = .center
    }
    
    internal func addColumnDown() {
        column_center_down = ComponentColumn(
            staffSlotHeight: staffSlotHeight, scale: scale, x: xRef, y_internal: yRef, y_external: yRef + column_down_height
        )
        components.append(column_center_down!)
        column_center_down!.alignment = .center
    }
}
