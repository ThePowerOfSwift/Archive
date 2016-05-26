//
//  Label.swift
//  DNM_iOS
//
//  Created by James Bean on 10/7/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit

public class Label: ViewNode {
    
    public var x: CGFloat = 0
    public var height: CGFloat = 0
    public var text: String = ""
    public var textLayer: TextLayerConstrainedByHeight!
    public var pad: CGFloat { get { return 0.25 * height } }
    
    public init(x: CGFloat = 0, top: CGFloat = 0, height: CGFloat = 10, text: String) {
        self.x = x
        self.height = height
        self.text = text
        super.init()
        self.top = top
        build()
    }
    
    public override init() { super.init() }
    public override init(layer: AnyObject) { super.init(layer: layer) }
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    public func build() {
        setVisualAttributes()
        createTextLayer()
        setFrame()
    }
    
    private func setVisualAttributes() {
        backgroundColor = DNMColorManager.backgroundColor.CGColor
    }
    
    public func createTextLayer() {
        let text_height = height - 2 * pad
        textLayer = TextLayerConstrainedByHeight(
            text: text,
            x: 0,
            top: pad,
            height: text_height,
            alignment: .Center,
            fontName: "Baskerville-SemiBold"
        )
        textLayer.foregroundColor = DNMColor.grayscaleColorWithDepthOfField(.Foreground).CGColor
        addSublayer(textLayer)
    }
    
    public func setFrame() {
        let w = textLayer.frame.width + 2 * pad
        frame = CGRectMake(x - 0.5 * w, top, w, height)
        textLayer.position.x = 0.5 * frame.width
    }
}