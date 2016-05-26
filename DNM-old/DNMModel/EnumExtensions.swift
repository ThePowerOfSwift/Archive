//
//  EnumExtensions.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

// Found here: http://stackoverflow.com/questions/24007461/how-to-enumerate-an-enum-with-string-type/32429125#32429125

import Foundation

public func iterateEnum<T: Hashable>(_: T.Type) -> AnyGenerator<T> {
    var i = 0
    return anyGenerator {
        let next = withUnsafePointer(&i) { UnsafePointer<T>($0).memory }
        return next.hashValue == i++ ? next : nil
    }
}