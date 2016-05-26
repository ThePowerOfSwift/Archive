//
//  ViewerProfile.swift
//  DNM_iOS
//
//  Created by James Bean on 12/16/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

/**
Holds the values of a Viewer, and all of the other Viewers for a ScoreViewModel
*/
public struct ViewerProfile {
    
    /// The current Viewer of a ScoreView
    public let viewer: Viewer
    
    /// The other Viewers within the performing context
    public let peers: [Viewer]
    
    /**
    Create a ViewerProfile with a viewer and peers

    - parameter viewer: Current Viewer of a ScoreView
    - parameter peers:  The other Viewers within the performing context

    - returns: ViewerProfile
    */
    public init(viewer: Viewer, peers: [Viewer]) {
        self.viewer = viewer
        self.peers = peers
    }
    
    /**
    Create a ViewerProfile with all Viewers in a performing context, and the current Viewer

    - parameter allViewers:    All Viewers in a performing context
    - parameter currentViewer: Current Viewer of a ScoreView

    - returns: ViewerProfile
    */
    public init(allViewers: [Viewer], currentViewer: Viewer) {
        self.viewer = currentViewer
        self.peers = allViewers.filter { $0 != currentViewer }
    }
}