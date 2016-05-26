//
//  GraphEventNode.swift
//  DNM_iOS
//
//  Created by James Bean on 9/30/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit

public class GraphEventNode: GraphEvent {
    
    public var nodeWidth: CGFloat { return 12 * scale }
    
    public override func build() {
        setFrame()
        moveArticulations()
        addNodeCircle()
    }
    
    private func addNodeCircle() {
        let circle = CAShapeLayer()
        let circlePath = UIBezierPath(
            ovalInRect: CGRect(
                x: 0,
                y: 0,
                width: frame.width,
                height: frame.height
            )
        )
        circle.path = circlePath.CGPath
        circle.fillColor = DNMColor.grayscaleColorWithDepthOfField(.MiddleForeground).CGColor
        addSublayer(circle)
    }
    
    internal override func setFrame() {
        super.setFrame()
        frame = CGRect(
            x: x - 0.5 * nodeWidth, y: -0.5 * nodeWidth, width: nodeWidth, height: nodeWidth
        )
    }
    
    internal override func getMinY() -> CGFloat {
        return sublayers?.map { $0.frame.minY }.minElement() ?? 0
    }
    
    internal override func getMaxY() -> CGFloat {
        return sublayers?.map { $0.frame.maxY }.maxElement() ?? 0
    }
}