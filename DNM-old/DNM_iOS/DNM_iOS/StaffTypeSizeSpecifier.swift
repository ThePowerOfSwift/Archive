//
//  StaffTypeSizeSpecifier.swift
//  DNM_iOS
//
//  Created by James Bean on 12/19/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

/**
Holds attributes defining the staffSpaceHeight and scale of a music notational object
*/
public struct StaffTypeSizeSpecifier {

    /// StaffSpaceHeight of notational object (default = 12.0)
    public var staffSpaceHeight: StaffSpaceHeight
    
    /// Scale of object (default = 1.0)
    public var scale: Scale
    
    /**
    Create a StaffTypeSizeSpecifier with StaffSpaceHeight and Scale

    - parameter staffSpaceHeight: StaffSpaceHeight of music notational object
    - parameter scale:       Scale of music notational object

    - returns: StaffTypeSizeSpecifier
    */
    public init(staffSpaceHeight: StaffSpaceHeight = 12.0, scale: Scale = 1.0) {
        self.staffSpaceHeight = staffSpaceHeight
        self.scale = scale
    }
}
