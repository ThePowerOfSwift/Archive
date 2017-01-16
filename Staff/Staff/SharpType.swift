//
//  SharpType.swift
//  Staff
//
//  Created by James Bean on 6/14/16.
//
//

import QuartzCore

public protocol SharpType {
    
    var thickLineSlope: CGFloat { get }
    var thickLineWidth: CGFloat { get }
    var thickLineLength: CGFloat { get }
}

extension SharpType where Self: Accidental {
    
    public var thickLineSlope: CGFloat { return 0.25 }
    public var thickLineWidth: CGFloat { return 0.382 * gS }
    public var thickLineLength: CGFloat { return midWidth + 2 * flankWidth }
}