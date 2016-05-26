//
//  ViewController.swift
//  denm
//
//  Created by James Bean on 1/9/15.
//  Copyright (c) 2015 James Bean. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // figure out where to put this (also, dynamic beatWidth (dynamic tempi, etc))
    let beatWidth: CGFloat = 125
    let selectRect: SelectRect = SelectRect()
    
    var performerView: PerformerView = PerformerView()
    
    //var page: Page = Page()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        CATransaction.setAnimationDuration(0.125)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))

        /*
        let augdot = AugmentationDot()
            .setX(100)
            .setY(100)
            .setWidth(20)
            .build()
        view.layer.addSublayer(augdot)
        */
        
        createHiddenTextViewForFootPedalInput()
        
        let path: String = NSBundle.mainBundle().pathForResource("drier_run", ofType: "txt")!
        let model = denm(filePath: path)
        let (spanTrees, measures) = model.getSpanTreesAndMeasures()
        
        performerView.setBeatWidth(beatWidth)
            .setAllMeasures(measures)
            .setAllSpanTrees(spanTrees)
            .setTop(20)
            .build()
        view.layer.addSublayer(performerView)
        
        
        /*
        // do this somewhere else?! -- this is now done in Interpreter // no, it's not
        var accumDur = Duration(0,16)
        for spanTree in spanTrees {
            spanTree.setOffsetDuration(accumDur)
            accumDur += spanTree.root.duration
        }
        page = Page()
            .setTop(20).setBeatWidth(beatWidth)
            .setAllMeasures(measures)
            .setAllSpanTrees(spanTrees)
            .build()
        view.layer.addSublayer(page)

        println(page)
        
        //page.printToPDF()

        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touchedPoint: CGPoint = touches.anyObject()!.locationInView(self.view)
        selectRect.scaleToPoint(touchedPoint)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        selectRect.removeFromSuperlayer()
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touchedPoint: CGPoint = touches.anyObject()!.locationInView(self.view)
        
        println(view.layer.hitTest(touchedPoint))
        println("STARTED: TOUCHED POINT: \(touchedPoint)")
        
        CATransaction.setDisableActions(true)
        selectRect.setInitialPoint(touchedPoint)
        view.layer.addSublayer(selectRect)
        CATransaction.setDisableActions(false)

        if let ts = view.layer.hitTest(touchedPoint) as? TimeSignature {
            println(ts.measure!)
            ts.measure!.tap()
        }
        
        if let mn = view.layer.hitTest(touchedPoint) as? MeasureNumber {
            mn.measure?.system?.switchIncludedStateOfTestBeamGroupAndStaff(x: mn.frame.midX)
        }
        
        if let mg = view.layer.hitTest(touchedPoint) as? MetronomeGraphic {
            mg.highlightForDuration(1)
        }
        
        if let mgGroup = view.layer.hitTest(touchedPoint) as? MGGroup {
            mgGroup.bgContainer?.play()
        }
        
        if let mgStratum = view.layer.hitTest(touchedPoint) as? MGStratum {
            mgStratum.exclude()
        }
        
        if let tb = view.layer.hitTest(touchedPoint) as? TupletBracket {
            tb.tap()
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override var keyCommands: [AnyObject]? {
        get {
            let pedal_left = UIKeyCommand(
                input: UIKeyInputUpArrow,
                modifierFlags: nil,
                action: Selector("pedal_left")
            )
            
            let pedal_right = UIKeyCommand(
                input: UIKeyInputDownArrow,
                modifierFlags: nil,
                action: Selector("pedal_right")
            )
            return [pedal_left, pedal_right]
        }
    }
    
    private func pedal_left() {
        println("pedal_left")
        //page.removeLastSystem()
    }
    
    private func pedal_right() {
        println("pedal_right")
        //apage.addNextSystem()
    }
    
    private func createHiddenTextViewForFootPedalInput() {
        let hiddenTextView = UITextView(frame: CGRectMake(0, 0, 0, 0))
        hiddenTextView.hidden = true
        hiddenTextView.text = ""
        view.addSubview(hiddenTextView)
        hiddenTextView.becomeFirstResponder()
    }
}

func itemInArray(#array: [String], item: String) -> Bool {
    for i in array { if i == item { return true } }
    return false
}