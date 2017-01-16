//
//  Notehead.swift
//  Staff
//
//  Created by James Bean on 6/14/16.
//
//

import QuartzCore
import PathTools

import Color

public final class Notehead: CAShapeLayer, NoteheadType {
    
    public enum Kind {
        case ord
        case diamondOpen
        case diamondClosed
        case circleOpen
        case circleClosed
        case squareOpen
        case squareClosed
        
        // TODO: Add custom identifier
    }
    
    public var point: CGPoint
    public var staffSlotHeight: StaffSlot
    
    public var color: Color = Color(gray: 0.5, alpha: 1) {
        didSet {
            fillColor = color.cgColor
        }
    }
    
    private var width: CGFloat {
        return 1.236 * CGFloat(staffSlotHeight)
    }
    
    private var height: CGFloat {
        return 0.75 * width
    }
    
    public init(point: CGPoint, staffSlotHeight: StaffSlot) {
        self.point = point
        self.staffSlotHeight = staffSlotHeight
        super.init()
        self.fillColor = Color(gray: 0.75, alpha: 1).cgColor
        build()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    public func makePath() -> CGPath {
        
        return Path.ellipse(rectangle: CGRect(x: 0, y: 0, width: width, height: height))
            .rotated(by: -45)
            .cgPath
    }
    
    public func makeFrame() -> CGRect {
        return CGRect(
            x: point.x - 0.5 * width,
            y: point.y - 0.5 * height,
            width: width,
            height: height
        )
    }
}
