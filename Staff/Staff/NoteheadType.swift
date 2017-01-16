//
//  NoteheadType.swift
//  Staff
//
//  Created by James Bean on 6/14/16.
//
//

import QuartzCore
import PathTools
import GraphicsTools


public protocol NoteheadType: ShapeType {
    
    var point: CGPoint { get }
}
