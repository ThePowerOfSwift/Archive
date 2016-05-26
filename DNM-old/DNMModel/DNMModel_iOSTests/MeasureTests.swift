//
//  MeasureTests.swift
//  DNMModel
//
//  Created by James Bean on 11/22/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class MeasureTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        let m0 = MeasureModel()
        XCTAssert(m0.duration == DurationZero, "duration somehow not nothing")
        let _m = MeasureModel(offsetDuration: Duration(2,8))
        XCTAssert(_m.offsetDuration == Duration(2,8), "offset duration set incorrectly")
        let m_ = MeasureModel(duration: Duration(3,16))
        XCTAssert(m_.duration == Duration(3,16), "duration set incorrectly")
        let _m_ = MeasureModel(duration: Duration(2,8), offsetDuration: Duration(3,16))
        XCTAssert(_m_.offsetDuration == Duration(3,16), "offset duration set incorrectly")
        XCTAssert(_m_.duration == Duration(2,8), "duration set incorrectly")
    }
    
    func testRangeFromArray() {
        

        var measures: [MeasureModel] = []
        var accumDur: Duration = DurationZero
        for _ in 0..<8 {
            let measure = MeasureModel(duration: Duration(4,8), offsetDuration: accumDur)
            measures.append(measure)
            accumDur += measure.duration
        }
        let maxDur = Duration(19, 16)
        let interval = DurationInterval(startDuration: DurationZero, stopDuration: maxDur)
        
        do {
            let range = try MeasureModel.rangeFromArray(measures, withinDurationInterval: interval)
            XCTAssert(range.count == 2, "should have two measures in there")
        }
        catch {
            print(error)
        }
    }
    
    func testDurationInterval() {
        let m = MeasureModel(duration: Duration(3,16), offsetDuration: Duration(2,8))

        XCTAssert(m.durationInterval.duration == Duration(3,16),
            "duration interval duration wrong"
        )
        XCTAssert(m.durationInterval.startDuration == Duration(2,8),
            "duration interval start duration wrong"
        )
        XCTAssert(m.durationInterval.stopDuration == Duration(7,16),
            "duration interval stop duration wrong"
        )
    }
    
    func testHasTimeSignature() {
        var m = MeasureModel()
        m.setHasTimeSignature(true)
        XCTAssert(m.hasTimeSignature, "has time signature not set correctly")
    }
    
    func testEquality() {
        let m1 = MeasureModel(duration: Duration(3,16), offsetDuration: Duration(2,8))
        let m2 = MeasureModel(duration: Duration(6,32), offsetDuration: Duration(1,4))
        XCTAssert(m1 == m2, "measures not equiv")
    }
    
    func testRangeFromMeasures() {
        let maximumDuration = Duration(19, 16)
        var measures: [MeasureModel] = []
        var accumDur: Duration = DurationZero
        for _ in 0..<8 {
            let measure = MeasureModel(duration: Duration(4,8), offsetDuration: accumDur)
            measures.append(measure)
            accumDur += measure.duration
        }
        
        let range = MeasureModel.rangeFromMeasures(measures, startingAtIndex: 0, constrainedByDuration: maximumDuration)
        XCTAssert(range != nil, "no range possible")
        XCTAssert(range!.count == 2, "range calculated incorrectly")
        
        // TODO: more robust tests
    }
    
    func testRangeFromMeasuresMeasureTooBig() {
        let maximumDuration = Duration(3,8)
        let measures = [ MeasureModel(duration: Duration(4,8)) ]
        let range = MeasureModel.rangeFromMeasures(measures, startingAtIndex: 0, constrainedByDuration: maximumDuration)
        XCTAssert(range == nil, "somehow not measure range not nil")
    }
}
