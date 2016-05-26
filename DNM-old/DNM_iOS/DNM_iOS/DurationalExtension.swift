//
//  DurationalExtension.swift
//  DNM_iOS
//
//  Created by James Bean on 8/23/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit

public class DurationalExtension: LigatureHorizontal {
    
    public var width: CGFloat = 0
    
    public init(y: CGFloat, left: CGFloat, right: CGFloat, width: CGFloat) {
        super.init(y: y, left: left, right: right)
        self.width = width
        build()
    }
    
    public override init() { super.init() }
    public override init(layer: AnyObject) { super.init(layer: layer) }
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    public override func setVisualAttributes() {
        lineWidth = width
        strokeColor = DNMColor.grayscaleColorWithDepthOfField(.Middleground).CGColor
        opacity = 0.666
    }
}
