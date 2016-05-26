//
//  ComponentFiltersTests.swift
//  DNMModel
//
//  Created by James Bean on 1/12/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class ComponentFiltersTests: XCTestCase {
    
    func testInit() {
        let componentFilters = ComponentFilters()
        print(componentFilters)
    }
    
    func testAddInitialComponentSelection() {
        
        // create duration interval (e.g., for a whole piece)
        let di0 = DurationInterval(
            startDuration: DurationZero,
            stopDuration: Duration(11,16)
        )
        
        // create componnent selection with duration interval
        let cs0 = ComponentFilter(durationInterval: di0)
        
        // init
        var componentFilters = ComponentFilters()
        
        // add component selections
        componentFilters.addComponentFilter(cs0)
        XCTAssertEqual(componentFilters.componentFilters.count, 1, "should have 1")
        XCTAssertEqual(componentFilters.durationInterval, di0, "should be same interval")
    }
    
    // change these with the new conception of overlapping selection
    func testAddMultipleComponentSpans() {
        
        // init selections
        var componentFilters = ComponentFilters()
        
        // add default selection for whole piece
        // |----------------------------------|
        let di0 = DurationInterval(startDuration: DurationZero, stopDuration: Duration(24,8))
        let cs0 = ComponentFilter(durationInterval: di0)
        componentFilters.addComponentFilter(cs0) // add default
        XCTAssertEqual(componentFilters.componentFilters.count, 1, "should be 1")
        
        // insert a selection
        // |----|==|--------------------------|
        let di1 = DurationInterval(startDuration: Duration(3,16), stopDuration: Duration(7,8))
        let cs1 = ComponentFilter(durationInterval: di1)
        componentFilters.addComponentFilter(cs1) // add insert
        XCTAssertEqual(componentFilters.componentFilters.count, 3, "should be 3")
        
        // insert a new, non overlapping selection
        // |----|==|--------|==========|------|
        let di2 = DurationInterval(startDuration: Duration(9,8), stopDuration: Duration(35,16))
        let cs2 = ComponentFilter(durationInterval: di2)
        componentFilters.addComponentFilter(cs2) // add a non overlapping insert
        XCTAssertEqual(componentFilters.componentFilters.count, 5, "should be 5")
        
        // insert selection starting at same duration as di1
        // |----|=======|---|==========|------|
        let di3 = DurationInterval(startDuration: Duration(3,16), stopDuration: Duration(8,8))
        let cs3 = ComponentFilter(durationInterval: di3)
        componentFilters.addComponentFilter(cs3)
        XCTAssertEqual(componentFilters.componentFilters.count, 6, "should be 6")
        
        // insert selection ending with stop duration of di2
        // |----|-------|---|--|=======|------|
        let di4 = DurationInterval(startDuration: Duration(11,8), stopDuration: Duration(35,16))
        let cs4 = ComponentFilter(durationInterval: di4)
        componentFilters.addComponentFilter(cs4)
        XCTAssertEqual(componentFilters.componentFilters.count, 7, "should be 7 now")
        
        // insert selection that matches exactly with cs4
        // |----|-------|---|--|=======|------|
        let di5 = DurationInterval(startDuration: Duration(11,8), stopDuration: Duration(35,16))
        let cs5 = ComponentFilter(durationInterval: di5)
        componentFilters.addComponentFilter(cs5)
        XCTAssertEqual(componentFilters.componentFilters.count, 7, "should still be 7")
        
        // insert selection that overlaps with many
        let di6 = DurationInterval(startDuration: Duration(2,16), stopDuration: Duration(37,16))
        let cs6 = ComponentFilter(durationInterval: di6)
        componentFilters.addComponentFilter(cs6)
        XCTAssertEqual(componentFilters.componentFilters.count, 9, "should be 9")
        print(componentFilters)
    }
    
    func testAddMultipleComponentSpansWithComponentTypes() {
        
        var componentFilters = ComponentFilters()
        
        let di0 = DurationInterval(startDuration: DurationZero, stopDuration: Duration(24,8))
        var cs0 = ComponentFilter(durationInterval: di0)
        
        cs0.componentTypeModel = [
            "VN": [
                "performer": .Show,
                "dynamics": .Show
            ],
            "VC": [
                "performer": .Show,
                "dynamics": .Show
            ]
        ]
        componentFilters.addComponentFilter(cs0)
        
        var expectedData: [ComponentTypeModel] = [
            [
                "VN": [
                    "performer": .Show,
                    "dynamics": .Show
                ],
                "VC": [
                    "performer": .Show,
                    "dynamics": .Show
                ]
            ]
        ]
        assertComponentSpansDataCorrect(componentFilters, expectedData: expectedData)
        
        let di1 = DurationInterval(startDuration: Duration(3,16), stopDuration: Duration(7,8))
        var cs1 = ComponentFilter(durationInterval: di1)
        cs1.componentTypeModel = [
            "VN": [
                "performer": .Hide
            ]
        ]
        componentFilters.addComponentFilter(cs1) // add insert
        
        expectedData = [
            [
                "VN": [
                    "performer": .Show,
                    "dynamics": .Show
                ],
                "VC": [
                    "performer": .Show,
                    "dynamics": .Show
                ]
            ],
            [
                "VN": [
                    "performer": .Hide,
                    "dynamics": .Show
                ],
                "VC": [
                    "performer": .Show,
                    "dynamics": .Show
                ]
            ],
            [
                "VN": [
                    "performer": .Show,
                    "dynamics": .Show
                ],
                "VC": [
                    "performer": .Show,
                    "dynamics": .Show
                ]
            ]
        ]
        assertComponentSpansDataCorrect(componentFilters, expectedData: expectedData)
        
        let di2 = DurationInterval(startDuration: Duration(9,8), stopDuration: Duration(35,16))
        var cs2 = ComponentFilter(durationInterval: di2)
        cs2.componentTypeModel = [
            "VC": [
                "dynamics": .Hide
            ]
        ]
        componentFilters.addComponentFilter(cs2)
        
        expectedData = [
            [
                "VN": [
                    "performer": .Show,
                    "dynamics": .Show
                ],
                "VC": [
                    "performer": .Show,
                    "dynamics": .Show
                ]
            ],
            [
                "VN": [
                    "performer": .Hide,
                    "dynamics": .Show
                ],
                "VC": [
                    "performer": .Show,
                    "dynamics": .Show
                ]
            ],
            [
                "VN": [
                    "performer": .Show,
                    "dynamics": .Show
                ],
                "VC": [
                    "performer": .Show,
                    "dynamics": .Show
                ]
            ],
            [
                "VN": [
                    "performer": .Show,
                    "dynamics": .Show
                ],
                "VC": [
                    "performer": .Show,
                    "dynamics": .Hide
                ]
            ],
            [
                "VN": [
                    "performer": .Show,
                    "dynamics": .Show
                ],
                "VC": [
                    "performer": .Show,
                    "dynamics": .Show
                ]
            ]
        ]
        assertComponentSpansDataCorrect(componentFilters, expectedData: expectedData)
        
        let di3 = DurationInterval(startDuration: Duration(2,16), stopDuration: Duration(37,16))
        var cs3 = ComponentFilter(durationInterval: di3)
        cs3.componentTypeModel = [
            "VC": [
                "performer": .Hide
            ]
        ]
        componentFilters.addComponentFilter(cs3)
        
        expectedData = [
            [
                "VN": [
                    "performer": .Show,
                    "dynamics": .Show
                ],
                "VC": [
                    "performer": .Show,
                    "dynamics": .Show
                ]
            ],
            [
                "VN": [
                    "performer": .Show,
                    "dynamics": .Show
                ],
                "VC": [
                    "performer": .Hide,
                    "dynamics": .Show
                ]
            ],
            [
                "VN": [
                    "performer": .Hide,
                    "dynamics": .Show
                ],
                "VC": [
                    "performer": .Hide,
                    "dynamics": .Show
                ]
            ],
            [
                "VN": [
                    "performer": .Show,
                    "dynamics": .Show
                ],
                "VC": [
                    "performer": .Hide,
                    "dynamics": .Show
                ]
            ],
            [
                "VN": [
                    "performer": .Show,
                    "dynamics": .Show
                ],
                "VC": [
                    "performer": .Hide,
                    "dynamics": .Hide
                ]
            ],
            [
                "VN": [
                    "performer": .Show,
                    "dynamics": .Show
                ],
                "VC": [
                    "performer": .Hide,
                    "dynamics": .Show
                ]
            ],
            [
                "VN": [
                    "performer": .Show,
                    "dynamics": .Show
                ],
                "VC": [
                    "performer": .Show,
                    "dynamics": .Show
                ]
            ]
        ]
        assertComponentSpansDataCorrect(componentFilters, expectedData: expectedData)
    }
    
    func assertComponentSpansDataCorrect(componentFilters: ComponentFilters,
        expectedData: [ComponentTypeModel]
        )
    {
        for (s, selection) in componentFilters.componentFilters.enumerate() {
            XCTAssert(
                selection.componentTypeModel == expectedData[s],
                "should be =="
            )
        }
    }
}
