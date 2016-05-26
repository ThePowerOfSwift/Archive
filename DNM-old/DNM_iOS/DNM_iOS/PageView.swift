//
//  PageView.swift
//  DNM_iOS
//
//  Created by James Bean on 10/2/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit
import DNMModel

/// UIView containing SystemViews for a single Page of music, contained by a ScoreView
public class PageView: UIView {

    public enum UIMode {
        case ComponentSelection
        case Performance
    }
    
    /// ScoreView that manages this PageView
    public var scoreView: ScoreView!
    
    /// The CALayer containing SystemLayers
    public var pageLayer: PageLayer!
    
    /// All SystemViews contained as subviews of this PageView
    public var systemViews: [SystemView] = []
    
    // TODO: unify language selected / touched
    
    /// All SystemViews selected by the user
    public var systemViewsSelected: [SystemView] = []
    
    /// The last SystemView selected by the user
    public var lastSystemViewTouched: SystemView?
    
    private var touchesStartedMoving: Bool = false
    
    public var uiMode: UIMode = .Performance
    
    private var selectedDurationInterval: DurationInterval? {
        if let start = durationSelected_initial, stop = durationSelected_final {
            return DurationInterval(oneDuration: start, andAnotherDuration: stop)
        }
        return nil
    }
    
    private var durationSelected_initial: Duration?
    private var durationSelected_final: Duration?
    
    /**
     Create a PageView with a PageLayer
     
     - parameter pageLayer:   Contains prebuilt SystemLayers
     - parameter systemViews: SystemViews for each SystemLayer
     - parameter scoreView:   The ScoreView that contains this PageView
     
     - returns: PageView
     */
    public init(pageLayer: PageLayer, systemViews: [SystemView], scoreView: ScoreView) {
        self.pageLayer = pageLayer
        self.scoreView = scoreView
        self.systemViews = systemViews
        super.init(frame: UIScreen.mainScreen().bounds)
        build()
    }
    
    public override init(frame: CGRect) { super.init(frame: frame) }
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    public func build() {
        layer.addSublayer(pageLayer)
        addSystemViews()
    }

    // MARK: - SystemView Management
    
    public func positionSystemViews() {
        systemViews.forEach { $0.setFrame() }
    }
    
    private func clearSystemViews() {
        systemViews.forEach { $0.removeFromSuperview() }
    }
    
    public func reflowSystems() {
        clearSystemViews()
        scoreView.reflowSystems()
        positionSystemViews()
    }

    public func clearSelectionRectangles() {
        systemViews.forEach { $0.hideSelectionRectangle() }
        systemViewsSelected = []
    }
    
    private func addSystemViews() {
        clearSystemViews()
        for systemView in systemViews {
            systemView.pageView = self
            addSubview(systemView)
        }
    }
    
    
    public func goToPreviousPage() {
        scoreView.goToPreviousPage()
    }
    
    public func goToNextPage() {
        scoreView.goToNextPage()
    }

    
    // MARK: - UI
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        clearSelectionRectangles()
        super.touchesCancelled(touches, withEvent: event)
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
    }
    
    // TODO: refactor
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        uiMode = .ComponentSelection
        
        if let point = touches.first?.locationInView(self) {
            
            // TODO: refactor
            if !touchesStartedMoving {
                if let point = touches.first?.locationInView(self) {
                    if let systemViewTouched = hitTest(point, withEvent: event) as? SystemView {
                        systemViewTouched.showSelectionRectangleAt(point)
                        lastSystemViewTouched = systemViewTouched
                        systemViewsSelected.append(systemViewTouched)
                        
                        // get duration selected start
                        durationSelected_initial = systemViewTouched.systemLayer.durationAt(
                            point.x
                        )
                        touchesStartedMoving = true
                    }
                }
            }
            
            // document this
            // wrap up in method
            if let systemViewTouched = hitTest(point, withEvent: event) as? SystemView {
                if let lastSystemViewTouched = lastSystemViewTouched {
                    if lastSystemViewTouched === systemViewTouched {
                        systemViewTouched.updateSelectionRectangleWith(point)
                    } else {
                        
                        // if we are currently selecting new selection
                        if systemViewsSelected.containsObject(systemViewTouched) {
                            lastSystemViewTouched.hideSelectionRectangle()
                            systemViewsSelected.removeObject(lastSystemViewTouched)
                        }
                        else {
                            systemViewsSelected.append(systemViewTouched)
                            let lastSystem = lastSystemViewTouched.systemLayer.viewModel.model
                            let lastDurationInterval = lastSystem.durationInterval
                            
                            let newSystem = systemViewTouched.systemLayer.viewModel.model
                            let newDurationInterval = newSystem.durationInterval
                            
                            if newDurationInterval.startDuration > lastDurationInterval.startDuration {
                                lastSystemViewTouched.updateSelectionRectangleToEnd()
                                systemViewTouched.showSelectionRectangleFromBeginning()
                                systemViewTouched.updateSelectionRectangleWith(point)
                                
                            } else {
                                lastSystemViewTouched.updateSelectionRectangleToBeginning()
                                systemViewTouched.showSelectionRectangleFromEnd()
                            }
                        }
                    }
                }
                lastSystemViewTouched = systemViewTouched
            }
            else if let lastSystemViewTouched = lastSystemViewTouched {
                lastSystemViewTouched.updateSelectionRectangleWith(point)
            }
        }
        super.touchesMoved(touches, withEvent: event)
    }
    
    // TODO: refactor
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let point = touches.first?.locationInView(self) {
            
            if !touchesStartedMoving { didTapAt(point) }
            else {
                
                switch uiMode {
                case .Performance:
                    break
                case .ComponentSelection:
                    // todo: refactor: get systemViewTouchedAtPoint(point, withEvent: event)
                    if let systemViewTouched = hitTest(point, withEvent: event) as? SystemView {
                        durationSelected_final = systemViewTouched.systemLayer.durationAt(point.x)
                        if let selectedDurationInterval = selectedDurationInterval {
                            scoreView.beginComposingComponentSpanWith(selectedDurationInterval)
                        }
                    }
                    else if let lastSystemViewTouched = lastSystemViewTouched {
                        durationSelected_final = lastSystemViewTouched.systemLayer.durationAt(point.x)
                        if let selectedDurationInterval = selectedDurationInterval {
                            scoreView.beginComposingComponentSpanWith(selectedDurationInterval)
                        }
                    }

                }
            }
        }
        super.touchesEnded(touches, withEvent: event)
        touchesStartedMoving = false
    }
    
    private func enterComponentSelectionMode() {
        uiMode = .ComponentSelection
    }
    
    private func exitComponentSelectionMode() {
        uiMode = .Performance
        clearSelectionRectangles()

    }
    
    private func didTapAt(point: CGPoint) {
        switch uiMode {
        case .ComponentSelection:
            exitComponentSelectionMode()
            clearSelectionRectangles()
            scoreView.commitComponentSpanInProcess()
            scoreView.hideComponentSelectorTableView()
        case .Performance:
            break
        }
        navigatePagesWithTapAt(point.x)
    }
    
    private func navigatePagesWithTapAt(x: CGFloat) {
        let halfOfScreen = 0.5 * frame.width
        x < halfOfScreen ? goToPreviousPage() : goToNextPage()
    }
}
