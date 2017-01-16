//
//  QuarterFlatUp.swift
//  Staff
//
//  Created by James Bean on 6/14/16.
//
//

import QuartzCore

public class QuarterFlatUp: QuarterFlat {
    
    public override var description: String { get { return "quarterFlatUp" } }
    
    public var arrow_up: ComponentArrow?
    
    internal override var column_up_height: CGFloat { get { return 2 * gS } }
    
    public override func createComponents() {
        addBody()
        addColumnUp()
        addColumnDown()
        addArrowUp()
    }
    
    internal func addArrowUp() {
        arrow_right_up = ComponentArrow(
            staffSlotHeight: staffSlotHeight,
            scale: scale,
            point: CGPoint(x: width, y: yRef - column_up_height),
            direction: .up
        )
        components.append(arrow_right_up!)
        arrow_right_up!.column = column_right_up
    }
}

