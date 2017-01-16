//
//  RelativeDirection+Z.swift
//  DirectionTools
//
//  Created by James Bean on 3/17/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

extension RelativeDirection {
    
    public class Z: EnumFamily {
        
        public static var Forwards: EnumKind = .Forwards
        public static var Backwards: EnumKind = .Backwards
        public static var None: EnumKind = .None
        
        public override class var members: [EnumKind] { return [Forwards, Backwards, None] }
    }
}