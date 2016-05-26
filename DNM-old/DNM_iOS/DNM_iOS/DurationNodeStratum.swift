//
//  DurationNodeStratum.swift
//  DNM_iOS
//
//  Created by James Bean on 12/19/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation
import DNMModel

public struct DurationNodeStratum: DurationSpanning {
    
    public var durationInterval: DurationInterval { return getDurationInterval() }
    
    public var durationNodes: [DurationNode] = []
    public var systemDurationOffset: Duration = DurationZero
    
    public init(durationNode: DurationNode, systemDurationOffset: Duration = DurationZero) {
        self.durationNodes = [durationNode]
        self.systemDurationOffset = systemDurationOffset
    }
    
    public init(durationNodes: [DurationNode], systemDurationOffset: Duration = DurationZero) {
        self.durationNodes = durationNodes
        self.systemDurationOffset = systemDurationOffset
    }
    
    public mutating func addDurationNode(durationNode: DurationNode) {
        durationNodes.append(durationNode)
    }
    
    private func getDurationInterval() -> DurationInterval {
        return DurationInterval.unionWithDurationIntervals(
            durationNodes.map { $0.durationInterval }
        )
    }
}

extension DurationNodeStratum: CustomStringConvertible {
    public var description: String {
        var result: String = "["
        durationNodes.forEach { result += "\n\t\($0)" }
        result += "]"
        return result
    }
}

// TODO: extend to CollectionType
extension DurationNodeStratum: SequenceType {
    
    public typealias Generator = AnyGenerator<DurationNode>
    
    public func generate() -> Generator {
        var index = 0
        return anyGenerator {
            if index < self.durationNodes.count { return self.durationNodes[index++] }
            return nil
        }
    }
}

public func + (lhs: DurationNodeStratum, rhs: DurationNodeStratum) -> DurationNodeStratum {
    return DurationNodeStratum(
        durationNodes: lhs.durationNodes + rhs.durationNodes,
        systemDurationOffset: lhs.systemDurationOffset
    )
}