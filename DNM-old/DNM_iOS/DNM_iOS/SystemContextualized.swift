//
//  SystemContextualized.swift
//  DNM_iOS
//
//  Created by James Bean on 1/1/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import QuartzCore
import DNMModel

internal protocol SystemContextualized {
    
    var viewerProfile: ViewerProfile { get}
    var systemOffsetDuration: Duration { get }
    var infoStartX: CGFloat { get }
    var beatWidth: BeatWidth { get }
    var defaultStaffHeight: StaffSpaceHeight { get }
    var scale: Scale { get }
    
    func staffSpaceHeightFor(performerID: PerformerID) -> StaffSpaceHeight
    func stemDirectionFor(performerID: PerformerID) -> StemDirection
    func xValueAt(duration: Duration) -> CGFloat
}

// MARK: - Default implementation

extension SystemContextualized {
    
    internal func scaleFor(performerID: PerformerID) -> Scale {
        switch performerID {
        case viewerProfile.viewer.identifier: return 1
        default: return 0.75
        }
    }
    
    internal func staffSpaceHeightFor(performerID: PerformerID) -> StaffSpaceHeight {
        switch performerID {
        case viewerProfile.viewer.identifier: return 12
        default: return 12 * 0.75
        }
    }
    
    internal func stemDirectionFor(performerID: PerformerID) -> StemDirection {
        return performerID == viewerProfile.viewer.identifier ? .Up : .Down
    }
    
    internal func xValueAt(duration: Duration) -> CGFloat {
        let xAtDuration = duration.width(beatWidth: beatWidth)
        let xAtSystemStart = systemOffsetDuration.width(beatWidth: beatWidth)
        let xDiff = xAtDuration - xAtSystemStart
        return xDiff + infoStartX
    }
}