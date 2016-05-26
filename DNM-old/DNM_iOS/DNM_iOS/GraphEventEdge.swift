//
//  GraphEventEdge.swift
//  DNM_iOS
//
//  Created by James Bean on 9/30/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit
import DNMModel

public class GraphEventEdge: GraphEvent {
    
    public override func build() {
        moveArticulations()
        addEdge()
        setFrame()
    }
    
    private func addEdge() {
        let height = 6 * scale
        let edge = CAShapeLayer()
        let edgePath = UIBezierPath(
            rect: CGRect(x: 0, y: -0.5 * height, width: width, height: height)
        )
        edge.path = edgePath.CGPath
        edge.fillColor = DNMColor.grayscaleColorWithDepthOfField(.Middleground).CGColor
        addSublayer(edge)
    }
}