//
//  DurationNodeIntervalInferring.swift
//  DNMModel
//
//  Created by James Bean on 1/18/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public class DurationNodeIntervalInferring: DurationNode {
    
    public override init() {
        super.init()
        self.isMetrical = false
        self.isNumerical = false
    }
    
    public override var durationInterval: DurationInterval {
        guard let start = minimumDuration() else { return DurationIntervalZero }
        guard let stop = maximumDuration() else { return DurationIntervalZero }
        return DurationInterval(startDuration: start, stopDuration: stop)
    }
    
    public func addChildAt(duration: Duration) -> DurationNode {
        let child = DurationNode.with(DurationInterval(startDuration: duration))
        addChild(child)
        updateChildren()
        return child
    }
        
    private func minimumDuration() -> Duration? {
        guard let children = children as? [DurationNodeIntervalEnforcing] else {
            return nil
        }
        return children.map { $0.durationInterval.startDuration }.minElement()
    }
    
    private func maximumDuration() -> Duration? {
        guard let children = children as? [DurationNodeIntervalEnforcing] else { return nil }
        return children.map { $0.durationInterval.stopDuration }.maxElement()
    }
    
    private func updateChildren() {
        sortChildren()
        setDurationIntervalsOfChildren()
    }
    
    private func setDurationIntervalsOfChildren() {
        if children.count == 1 {
            (children[0] as! DurationNodeIntervalEnforcing).duration = Duration(1,64)
        }
        guard children.count > 1 else { return }
        guard let children = children as? [DurationNodeIntervalEnforcing] else { return }
        for c in 1..<children.count {
            let child1 = children[c-1]
            let child2 = children[c]
            child1.duration = child2.offsetDuration - child1.offsetDuration
        }
    }
    
    private func sortChildren() {
        guard let children = children as? [DurationNodeIntervalEnforcing] else { return }
        self.children = children.sort {
            $0.durationInterval.startDuration < $1.durationInterval.startDuration
        }
    }
}