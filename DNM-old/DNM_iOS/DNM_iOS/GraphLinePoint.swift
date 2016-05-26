//
//  GraphLinePoint.swift
//  DNM
//
//  Created by James Bean on 1/10/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import QuartzCore

public protocol GraphLinePoint {
    
    var x: CGFloat { get }
    init(x: CGFloat)
}

public struct GraphLinePointStart: GraphLinePoint {
    
    public let x: CGFloat
    
    public init(x: CGFloat) {
        self.x = x
    }
}

public struct GraphLinePointStop: GraphLinePoint {
    
    public let x: CGFloat
    
    public init(x: CGFloat) {
        self.x = x
    }
}