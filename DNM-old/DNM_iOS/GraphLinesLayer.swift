//
//  GraphLinesLayer.swift
//  DNM
//
//  Created by James Bean on 1/10/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import QuartzCore

public class GraphLinesLayer: CALayer {
    
    private var lines: [GraphLine] = []
    
    public override init() {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    /**
     Add GraphLine to GraphLinesLayer from left to right, at y
     
     - parameter left:  Left point of GraphLine
     - parameter right: Right point of GraphLine
     - parameter y:     Y value of GraphLine
     */
    public func addLineFrom(left: CGFloat, to right: CGFloat, at y: CGFloat) {
        let line = GraphLine(left: left, right: right, y: y)
        lines.append(line)
    }
    
    public func addLine(graphLine: GraphLine) {
        lines.append(graphLine)
    }
    
    internal func build() {
        lines.forEach { addSublayer($0) }
    }
}