//
//  RelativeDirection+Y.swift
//  DirectionTools
//
//  Created by James Bean on 3/17/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

extension RelativeDirection {
    
    public class Y: EnumFamily {
        
        public static var Up: EnumKind = .Up
        public static var Down: EnumKind = .Down
        public static var None: EnumKind = .None
        
        public override class var members: [EnumKind] { return [Up, Down, None] }
    }
}