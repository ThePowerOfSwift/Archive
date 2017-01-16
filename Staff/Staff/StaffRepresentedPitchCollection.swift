//
//  StaffRepresentedPitchCollection.swift
//  Staff
//
//  Created by James Bean on 6/15/16.
//
//

import QuartzCore
import Pitch
import PitchSpellingTools

public struct StaffRepresentedPitchCollection {
    
    fileprivate var contexts: [StaffRepresentedPitch] = []
    
    public init(_ contexts: [StaffRepresentedPitch]) {
        self.contexts = contexts
    }
}

extension StaffRepresentedPitchCollection: Sequence {
    
    public func generate() -> AnyIterator<StaffRepresentedPitch> {
        var iterator = contexts.makeIterator()
        return AnyIterator { return iterator.next() }
    }
}

extension StaffRepresentedPitchCollection: Collection {
    /// Returns the position immediately after the given index.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    /// - Returns: The index value immediately after `i`.
    public func index(after i: Int) -> Int {
        return contexts.index(after: i)
    }
    
    public var startIndex: Int { return 0 }
    
    public var endIndex: Int { return contexts.count }
    
    public subscript (index: Int) -> StaffRepresentedPitch {
        return contexts[index]
    }
}
