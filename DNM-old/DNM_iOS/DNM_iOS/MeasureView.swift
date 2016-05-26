//
//  MeasureModel.swift
//  DNM_iOS
//
//  Created by James Bean on 8/19/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit
import DNMModel

public class MeasureView: ViewNode, BuildPattern {
    
    public override var description: String { get { return getDescription() } }
    
    public var system: SystemLayer?
    
    public var measure: MeasureModel?
    
    // deprecate these: just use .measure.durationInterval._ ------>
    public var offsetDur: Duration = DurationZero
    public var dur: Duration?
    // <---------------------
    
    public var g: CGFloat = 0
    public var scale: CGFloat = 0
    public var height: CGFloat = 200 // to be set by system
    public var number: Int = 0
    
    public var beatWidth: CGFloat = 0
    
    public var barlineLeft: Barline?
    public var barlineRight: Barline?
    
    public var timeSignature: TimeSignature?
    public var measureNumber: MeasureNumber?
    
    public var hasTimeSignature: Bool = true
    
    public var hasBeenBuilt: Bool = false
    
    public class func rangeFromMeasures(
        measures: [MeasureView],
        startingAtIndex index: Int,
        constrainedByMaximumTotalWidth maximumWidth: CGFloat
    ) -> [MeasureView]
    {
        var measureRange: [MeasureView] = []
        var m: Int = index
        var accumLeft: CGFloat = 0
        while m < measures.count && accumLeft < maximumWidth {
            let measure_width = measures[m].dur!.width(beatWidth: measures[m].beatWidth)
            if accumLeft + measure_width <= maximumWidth {
                measureRange.append(measures[m])
                accumLeft += measure_width
                m++
            }
            else { break }
        }
        return measureRange
    }
    
    public init(measure: MeasureModel) {
        self.measure = measure
        self.hasTimeSignature = measure.hasTimeSignature
        self.offsetDur = measure.offsetDuration
        self.dur = measure.duration
        self.number = measure.number
        super.init()
    }
    
    public init(offsetDuration: Duration) {
        self.offsetDur = offsetDuration
        super.init()
    }
    
    public init(duration: Duration) {
        self.dur = duration
        super.init()
    }
    
    public init(
        duration: Duration,
        number: Int,
        g: CGFloat,
        scale: CGFloat,
        left: CGFloat,
        beatWidth: CGFloat
    )
    {
        self.dur = duration
        self.number = number
        self.g = g
        self.scale = scale
        self.beatWidth = beatWidth
        super.init()
        self.left = left
        build()
    }
    
    public override init() { super.init() }
    public override init(layer: AnyObject) { super.init(layer: layer) }
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    public func setDuration(duration: Duration) {
        self.dur = duration
    }
    
    public func build() {
        setFrame()
        addMeasureNumber()
        if hasTimeSignature { addTimeSignature() }
        hasBeenBuilt = true
    }
    
    public func addBarlineLeft() {
        barlineLeft = Barline(x: 0, top: timeSignature!.frame.maxY + g, bottom: 200)
        barlineLeft?.lineWidth = 0.382 * g
        addSublayer(barlineLeft!)
    }
    
    public func addBarlineRight() {
        barlineRight = Barline(x: frame.width, top: timeSignature!.frame.maxY + g, bottom: 200)
        barlineRight?.lineWidth = 0.382 * g
        addSublayer(barlineRight!)
    }
    
    // modify this to work with new TemporalInfoNode infrastructrue
    private func addTimeSignature() {
        timeSignature = TimeSignature(
            numerator: dur!.beats!.amount,
            denominator: dur!.subdivision!.value,
            x: 0,
            top: 0,
            height: 3.82 * g
        )
        timeSignature?.measure = self
        addSublayer(timeSignature!)
    }
    
    // modify this to work with new TemporalInfoNode infrastructrue
    private func addMeasureNumber() {
        measureNumber = MeasureNumber(number: number, x: 0, top: 0, height: 1.618 * g)
        measureNumber?.measure = self
        addSublayer(measureNumber!)
    }
    
    private func addBarline() {
        // to be handed off later?
        barlineLeft = Barline(x: 0, top: 2.25 * g, bottom: 0)
        addSublayer(barlineLeft!)
    }
    
    private func setFrame() {
        //let width = dur!.getGraphicalWidth(beatWidth: beatWidth)
        //let width = graphicalWidth(duration: dur!, beatWidth: beatWidth)
        let width = dur!.width(beatWidth: beatWidth)
        frame = CGRectMake(0, 0, width, 0)
    }
    
    private func getDescription() -> String {
        return "MeasureModel: \(dur!), offset: \(offsetDur)"
    }
}




