//
//  StaffRepresentablePitchCollection.swift
//  Staff
//
//  Created by James Bean on 6/15/16.
//
//

import PitchSpellingTools

public struct StaffRepresentablePitchCollection {
    
    fileprivate var contexts: [StaffRepresentablePitch] = []
    
    public init(_ contexts: [StaffRepresentablePitch]) {
        self.contexts = contexts
    }
    
    public mutating func addSpelledPitch(
        spelledPitch: SpelledPitch,
        representedBy noteheadKind: Notehead.Kind = .ord
    )
    {
        let context = StaffRepresentablePitch(spelledPitch, noteheadKind)
        contexts.append(context)
    }
    
    public mutating func addContext(context: StaffRepresentablePitch) {
        contexts.append(context)
    }
}

extension StaffRepresentablePitchCollection: Sequence {
    
    public func generate() -> AnyIterator<StaffRepresentablePitch> {
        var iterator = contexts.makeIterator()
        return AnyIterator { iterator.next() }
    }
}

extension StaffRepresentablePitchCollection: Collection {
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
    public subscript (index: Int) -> StaffRepresentablePitch {
        return contexts[index]
    }
}
