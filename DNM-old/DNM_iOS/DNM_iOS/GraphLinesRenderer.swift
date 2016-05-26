//
//  GraphLinesRenderer.swift
//  DNM
//
//  Created by James Bean on 1/10/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import UIKit

public class GraphLinesRenderer {
    
    internal let linePoints: [GraphLinePoint]
    
    public init(linePoints: [GraphLinePoint]) {
        self.linePoints = linePoints
    }
    
    public func renderGraphLinesLayer() -> GraphLinesLayer {
        
        return GraphLinesLayer()
    }
    
    internal func commitLineFrom(
        left: CGFloat, to right: CGFloat, toGraphLinesLayer layer: GraphLinesLayer
    )
    {
        let y: CGFloat = 0
        layer.addLineFrom(left, to: right, at: y)
    }
}

// TODO: extend StaffLinesRenderer to accomodate different amounts of lines. Not yet needed.
public class StaffLinesRenderer: GraphLinesRenderer {
    
    internal let staffSpaceHeight: StaffSpaceHeight
    internal let amountLines: Int = 5
    
    public init(linePoints: [GraphLinePoint], staffSpaceHeight: StaffSpaceHeight) {
        self.staffSpaceHeight = staffSpaceHeight
        super.init(linePoints: linePoints)
    }
}