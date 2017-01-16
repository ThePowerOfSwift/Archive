//
//  RelativeDirection+X.swift
//  DirectionTools
//
//  Created by James Bean on 3/17/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

extension RelativeDirection {
    
    public class X: EnumFamily {
        
        public static var Left: EnumKind = .Left
        public static var Right: EnumKind = .Right
        public static var None: EnumKind = .None
        
        public override class var members: [EnumKind] { return [ Left, Right, None ] }
    }
}