//
//  Barline.swift
//  DNM_iOS
//
//  Created by James Bean on 10/6/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit

public class Barline: LigatureVertical/*, Playable*/ {
    
    public override func setVisualAttributes() {
        strokeColor = DNMColor.grayscaleColorWithDepthOfField(.Background).CGColor
    }
    
    public func play() {
        strokeColor = UIColor.redColor().CGColor
    }
    
    public func playNext() {
        // nothing, just to appease Playable protocol, will disappear
    }
}