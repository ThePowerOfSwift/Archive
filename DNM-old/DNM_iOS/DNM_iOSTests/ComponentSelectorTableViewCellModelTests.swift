//
//  ComponentSelectorTableViewCellModelTests.swift
//  DNM_iOS
//
//  Created by James Bean on 12/16/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import XCTest

class ComponentSelectorTableViewCellModelTests: XCTestCase {

    func testInit() {
        let cellModel0 = ComponentSelectorTableViewCellModel(
            componentType: "dynamics",
            states: [.Show, .Hide, .Show],
            belongsToCurrentViewer: false
        )
        XCTAssert(cellModel0.text == "dynamics")
        XCTAssert(cellModel0.state == .MultipleValues )
        XCTAssert(cellModel0.belongsToCurrentViewer == false)
        
        let cellModel1 = ComponentSelectorTableViewCellModel(
            componentType: "articulations",
            states: [.Show, .Show, .Show],
            belongsToCurrentViewer: true
        )
        XCTAssert(cellModel1.belongsToCurrentViewer == true)
        XCTAssert(cellModel1.state == .On)
    }
    
    func testState() {
        var cellModelWithMultipleComponentTypeStates = ComponentSelectorTableViewCellModel(
            componentType: "pitches",
            states: [.Hide, .Show, .Hide, .Hide],
            belongsToCurrentViewer: true
        )
        XCTAssert(cellModelWithMultipleComponentTypeStates.state == .MultipleValues)
        
        cellModelWithMultipleComponentTypeStates.mute()
        XCTAssert(cellModelWithMultipleComponentTypeStates.state == .Muted)
        
        cellModelWithMultipleComponentTypeStates.unmute()
        XCTAssert(cellModelWithMultipleComponentTypeStates.state == .MultipleValues)

        // turn cell on
        cellModelWithMultipleComponentTypeStates.state = .On
        cellModelWithMultipleComponentTypeStates.mute()
        XCTAssert(cellModelWithMultipleComponentTypeStates.state == .Muted)
        
        cellModelWithMultipleComponentTypeStates.unmute()
        XCTAssert(cellModelWithMultipleComponentTypeStates.state == .On)
    }
    
    func testNextStateWithOneState() {
        var cellModelWithOneState = ComponentSelectorTableViewCellModel(
            componentType: "dynamics",
            states: [.Show, .Show, .Show],
            belongsToCurrentViewer: false
        )
        
        cellModelWithOneState.mute()
        XCTAssert(cellModelWithOneState.state == .Muted)
        
        cellModelWithOneState.unmute()
        XCTAssert(cellModelWithOneState.state == .On)

        cellModelWithOneState.goToNextState()
        XCTAssert(cellModelWithOneState.state == .Off)

        cellModelWithOneState.goToNextState()
        XCTAssert(cellModelWithOneState.state == .On)
        
        cellModelWithOneState.goToNextState()
        XCTAssert(cellModelWithOneState.state == .Off)
    }
    
    func testNextStateWithMultipleStates() {
        var cellModelWithMultiplestates = ComponentSelectorTableViewCellModel(
            componentType: "slurs",
            states: [.Show, .Hide, .Show, .Show, .Hide],
            belongsToCurrentViewer: true
        )
        
        XCTAssert(cellModelWithMultiplestates.state == .MultipleValues)
        
        cellModelWithMultiplestates.goToNextState()
        XCTAssert(cellModelWithMultiplestates.state == .On)
        
        cellModelWithMultiplestates.goToNextState()
        XCTAssert(cellModelWithMultiplestates.state == .Off)
        
        cellModelWithMultiplestates.goToNextState()
        XCTAssert(cellModelWithMultiplestates.state == .MultipleValues)
        
        cellModelWithMultiplestates.mute()
        XCTAssert(cellModelWithMultiplestates.state == .Muted)
        
        cellModelWithMultiplestates.goToNextState()
        XCTAssert(cellModelWithMultiplestates.state == .Off)
        
        cellModelWithMultiplestates.goToNextState()
        XCTAssert(cellModelWithMultiplestates.state == .MultipleValues)
        
        cellModelWithMultiplestates.unmute()
        XCTAssert(cellModelWithMultiplestates.state == .MultipleValues)
    }
}
