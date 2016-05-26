//
//  SystemView.swift
//  DNM_iOS
//
//  Created by James Bean on 10/2/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit
import DNMModel

public class SystemView: UIView {
    
    public var systemLayer: SystemLayer!
    public var pageView: PageView!
    public var selectionRectangle: SelectionRectangle?
    
    public var selectedDurationInterval: DurationInterval? {
        if let start = durationSelected_start, stop = durationSelected_stop {
            return DurationInterval(oneDuration: start, andAnotherDuration: stop)
        }
        return nil
    }
    
    // start / stop are dangerous, as they actually are NOT necessarily ordered, at this point
    private var durationSelected_start: Duration?
    private var durationSelected_stop: Duration?
    
    public init(system: SystemLayer, pageView: PageView? = nil) {
        self.systemLayer = system
        self.pageView = pageView
        super.init(frame: system.frame)
    }
    
    public override init(frame: CGRect) { super.init(frame: frame) }
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }

    public func setFrame() {
        frame = systemLayer.frame
    }
    
    // MARK: - UI
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let point = touches.first?.locationInView(self) {
            durationSelected_start = systemLayer.durationAt(point.x)
        }
        super.touchesBegan(touches, withEvent: event)
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
    }

    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
    }
    
    // MARK: - UI Utility
    
    private func setSelectedDurationIntervalWithPoint(point: CGPoint) {
        durationSelected_stop = systemLayer.durationAt(point.x)
    }
    
    private func convertedFrameForSelectionRectangle(selectionRectangle: SelectionRectangle)
        -> CGRect
    {
        return systemLayer.eventsNode.convertRect(selectionRectangle.frame,
            fromLayer: systemLayer
        )
    }
    
    // MARK: - SelectionRectangle
    
    public func showSelectionRectangleAt(point: CGPoint) {
        selectionRectangle = SelectionRectangle(x: point.x, height: frame.height)
        layer.addSublayer(selectionRectangle!)
    }
    
    public func showSelectionRectangleFromEnd() {
        showSelectionRectangleAt(CGPoint(x: frame.width, y: 0))
    }
    
    public func updateSelectionRectangleToEnd() {
        if let selectionRectangle = selectionRectangle {
            selectionRectangle.scaleWidthWithPoint(point: CGPoint(x: frame.width, y: 0))
        }
    }
    
    public func showSelectionRectangleFromBeginning() {
        let infoStartX = systemLayer.infoStartX
        showSelectionRectangleAt(CGPoint(x: infoStartX, y: 0))
    }
    
    public func updateSelectionRectangleToBeginning() {
        if let selectionRectangle = selectionRectangle {
            let infoStartX = systemLayer.infoStartX
            selectionRectangle.scaleWidthWithPoint(point: CGPoint(x: infoStartX, y: 0))
        }
    }
    
    public func updateSelectionRectangleWith(point: CGPoint) {
        if let selectionRectangle = selectionRectangle {
            selectionRectangle.scaleWidthWithPoint(point: point)
        }
    }
    
    public func hideSelectionRectangle() {
        selectionRectangle?.removeFromSuperlayer()
        selectionRectangle = nil
    }
}