//
//  DurationNodeTests.swift
//  DNMModel_iOSTests
//
//  Created by James Bean on 3/21/15.
//  Copyright (c) 2015 James Bean. All rights reserved.
//

import UIKit
import XCTest
@testable import DNMModel

class DurationNodeTests: XCTestCase {
    
    /*
    func testInit() {
        let durNode: DurationNode = DurationNode.with(Duration(5,16))
        XCTAssert(durNode.duration == Duration(5,16))
    }
    
    func testDurationInterval() {
        let dn = DurationNodeIntervalEnforcing(duration: Duration(9,16), offsetDuration: Duration(2,8))
        let di = DurationInterval(duration: Duration(9,16), startDuration: Duration(2,8))
        XCTAssert(dn.durationInterval == di, "duration interval wrong")
    }
    
    func testInitWithStringNil() {
        let durationNode = DurationNode(string: "")
        XCTAssert(durationNode == nil)
    }

    func testHasComponentWithPerformerIDTrue() {
        let durationNode = DurationNodeIntervalEnforcing(duration: Duration(1,8))
        durationNode.addComponent(
            ComponentPitch(performerID: "VN", instrumentID: "vn", values: [60])
        )
        XCTAssert(durationNode.hasComponentWithPerformerID("VN"))
    }
    
    func testHasComponentWithPerformerIDFalse() {
        let durationNode = DurationNodeIntervalEnforcing(duration: Duration(1,8))
        durationNode.addComponent(
            ComponentPitch(performerID: "VN", instrumentID: "vn", values: [60])
        )
        XCTAssert(!durationNode.hasComponentWithPerformerID("FL"))
    }
    
    func testHasComponentWithTypeTrue() {
        let durationNode = DurationNodeIntervalEnforcing(duration: Duration(1,8))
        durationNode.addComponent(
            ComponentPitch(performerID: "VN", instrumentID: "vn", values: [60])
        )
        XCTAssert(durationNode.hasComponentWithType("pitches"))
    }
    
    func testHasComponentWithTypeFalse() {
        let durationNode = DurationNodeIntervalEnforcing(duration: Duration(1,8))
        durationNode.addComponent(
            ComponentPitch(performerID: "VN", instrumentID: "vn", values: [60])
        )
        XCTAssert(!durationNode.hasComponentWithType("dynamics"))
    }
    
    func testCopyWithComponentsForPerformerIDAndInstrumentID() {
        let dn = DurationNodeIntervalEnforcing(duration: Duration(3,16))
        dn.components = [
            ComponentPitch(performerID: "VN", instrumentID: "vn", values: [60]),
            ComponentArticulation(performerID: "VN", instrumentID: "vn", values: ["."]),
            ComponentDynamicMarking(performerID: "VN", instrumentID: "vn", value: "ppp"),
            ComponentPitch(performerID: "VN", instrumentID: "vx", values: [63]),
            ComponentArticulation(performerID: "VN", instrumentID: "vx", values: ["-"]),
            ComponentPitch(performerID: "VC", instrumentID: "vc", values: [62]),
            ComponentDynamicMarking(performerID: "VC", instrumentID: "vc", value: "fff")
        ]
        let dnVNvn = dn.copyWithComponentsFor(InstrumentIdentifierPath("VN", "vn"))
        let expectedVNvn: [Component] = [
            ComponentPitch(performerID: "VN", instrumentID: "vn", values: [60]),
            ComponentArticulation(performerID: "VN", instrumentID: "vn", values: ["."]),
            ComponentDynamicMarking(performerID: "VN", instrumentID: "vn", value: "ppp"),
        ]
        XCTAssert(dnVNvn.components.count == expectedVNvn.count)

        let dnVNvx = dn.copyWithComponentsFor(InstrumentIdentifierPath("VN", "vx"))
        let expectedVNvx: [Component] = [
            ComponentPitch(performerID: "VN", instrumentID: "vx", values: [63]),
            ComponentArticulation(performerID: "VN", instrumentID: "vx", values: ["-"])
        ]
        XCTAssert(dnVNvx.components.count == expectedVNvx.count)
        
        
        let dnVCvc = dn.copyWithComponentsFor(InstrumentIdentifierPath("VC", "vc"))
        let expectedVCvc: [Component] = [
            ComponentPitch(performerID: "VC", instrumentID: "vc", values: [62]),
            ComponentDynamicMarking(performerID: "VC", instrumentID: "vc", value: "fff")
        ]
        XCTAssert(dnVCvc.components.count == expectedVCvc.count)
    }
    
    func testClearComponents() {
        let dn = DurationNodeIntervalEnforcing(duration: Duration(3,16))
        dn.addComponent(ComponentExtensionStart())
        dn.addComponent(ComponentExtensionStop())
        dn.addComponent(ComponentPitch(performerID: "", instrumentID: "", values: [60]))
        XCTAssert(dn.components.count > 0, "should have components in there")
        // break into separate test
        dn.clearComponents()
        XCTAssert(dn.components.count == 0, "should have no components")
        XCTAssert(dn.instrumentIDsByPerformerID.count == 0, "all iids and pids should be cleared")
    }
    
    // TODO: break into multiple tests
    func testHasOnlyExtensionComponents() {
        let dn = DurationNodeIntervalEnforcing(duration: Duration(3,16))
        
        // add extension start
        dn.addComponent(ComponentExtensionStart())
        XCTAssert(dn.hasOnlyExtensionComponents, "should only have one extension component")
        
        XCTAssert(dn.hasExtensionStart, "should have extension start")
        XCTAssert(!dn.hasExtensionStop, "should not have extension start")
        
        // add extension stop
        dn.addComponent(ComponentExtensionStop())
        XCTAssert(dn.hasOnlyExtensionComponents, "should have two extension components")
        
        XCTAssert(dn.hasExtensionStart, "should have extension start")
        XCTAssert(dn.hasExtensionStop, "should have extension start")
        
        // add pitch
        dn.addComponent(ComponentPitch(performerID: "", instrumentID: "", values: [60]))
        XCTAssert(!dn.hasOnlyExtensionComponents, "should not have only extension components")
    }
    
    func testInstrumentIDsByPerformerID() {
        let root = DurationNodeIntervalEnforcing(duration: Duration(3,16))
        
        let c1 = DurationNodeIntervalEnforcing(duration: Duration(1,16))
        c1.addComponent(ComponentPitch(performerID: "VN", instrumentID: "vn", values: [60]))
        c1.addComponent(ComponentPitch(performerID: "VN", instrumentID: "vx", values: [60.25]))
        root.addChild(c1)
        
        let c2 = DurationNodeIntervalEnforcing(duration: Duration(1,16))
        c2.addComponent(ComponentPitch(performerID: "VC", instrumentID: "vc", values: [40]))
        root.addChild(c2)
        
        let c3 = DurationNodeIntervalEnforcing(duration: Duration(1,16))
        c3.addComponent(ComponentPitch(performerID: "VC", instrumentID: "vc", values: [60.5]))
        root.addChild(c3)
        
        XCTAssert(root.instrumentIDsByPerformerID == ["VN": ["vn","vx"], "VC": ["vc"]], "iids wrong")
    }
    
    func testAddChildWithBeats() {
        let root = DurationNodeIntervalEnforcing(duration: Duration(1,16))
        root.addChildWithBeats(1)
        if let firstChild = root.children.first as? DurationNode {
            XCTAssert(firstChild.durationInterval.startDuration == DurationZero)
            if let beats = firstChild.duration.beats,
                subdivision = firstChild.duration.subdivision
            {
                XCTAssert(beats.amount == 1)
                XCTAssert(subdivision.value == 16)
            } else {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }
    
    func testSubdivisionOfChildren() {
        let root = DurationNodeIntervalEnforcing(duration: Duration(1,8), sequence: [1,1,1])
        XCTAssert(root.subdivisionOfChildren != nil, "should not be nil")
        XCTAssert(root.subdivisionOfChildren! == Subdivision(value: 16), "subdivision wrong")
        
        // go deeper
    }
    
    func testIsSubdividable() {
        let root_s = DurationNodeIntervalEnforcing(duration: Duration(2,8), sequence: [1,1,1,1])
        XCTAssert(root_s.isSubdividable, "should be subdividable")
        
        let root_ns0 = DurationNodeIntervalEnforcing(duration: Duration(2,8), sequence: [1,1,1])
        XCTAssert(!root_ns0.isSubdividable, "should not be subdividable")
        
        let root_ns1 = DurationNodeIntervalEnforcing(duration: Duration(3,8), sequence: [1,1,1,1])
        XCTAssert(!root_ns1.isSubdividable, "should not be subdividable")
    }
    
    func testCopy() {
        let durNode: DurationNode = DurationNodeIntervalEnforcing(duration: Duration(5,16))
        let child1 = DurationNodeIntervalEnforcing(duration: Duration(3,16))
        let child2 = DurationNodeIntervalEnforcing(duration: Duration(4,32))
        let child3 = DurationNodeIntervalEnforcing(duration: Duration(13,128))
        durNode.addChild(child1)
        durNode.addChild(child2)
        durNode.addChild(child3)
        
        // copy duration node
        let newDurNode: DurationNode = durNode.copy()
        XCTAssert(durNode.duration == newDurNode.duration, "dur not set correctly")
        XCTAssert((newDurNode.children[0] as! DurationNode).duration == child1.duration,
            "child dur not set correctly")
        XCTAssert(newDurNode.children[0] !== child1, "durNodes equiv")
        XCTAssert(newDurNode.children.count == 3, "all durNodes not added")
        XCTAssert(durNode !== newDurNode, "nodes are equiv")
    }
    
    func testCopyWithComponents() {
        let dn0 = DurationNodeIntervalEnforcing(duration: Duration(3,16))
        dn0.components = [
            ComponentPitch(performerID: "", instrumentID: "", values: [60]),
            ComponentDynamicMarking(performerID: "", instrumentID: "", value: "ffff")
        ]

        
        let dn_copy = dn0.copy()
        print(dn_copy)
        XCTAssert(dn_copy == dn0)
        XCTAssert(dn_copy !== dn0)
        
        // filter out pitch
        dn_copy.components = dn_copy.components.filter { $0.type != "pitches" }
        
        //XCTAssert(dn_copy.components != dn0.components)
    }
    
    
    func testLevelChildren() {
        let durNode: DurationNode = DurationNodeIntervalEnforcing(duration: Duration(5,16))
        let child1 = DurationNodeIntervalEnforcing(duration: Duration(3,16))
        let child2 = DurationNodeIntervalEnforcing(duration: Duration(4,32))
        let child3 = DurationNodeIntervalEnforcing(duration: Duration(13,128))
        durNode.addChild(child1)
        durNode.addChild(child2)
        durNode.addChild(child3)
        print("durNode before level: \(durNode)")
        XCTAssert(durNode.getMaximumSubdivisionOfChildren()! == Subdivision(value: 128), "getMaxSubdivision not called correctly")
        durNode.levelDurationsOfChildren()
        print("durNode after level: \(durNode)")
        
        durNode.levelDurationsOfChildren()
        print("durNode after second level: \(durNode)")
    }
    
    func testReduceChildren() {
        let durNode: DurationNode = DurationNodeIntervalEnforcing(duration: Duration(5,16))
        let child1 = DurationNodeIntervalEnforcing(duration: Duration(3,16))
        let child2 = DurationNodeIntervalEnforcing(duration: Duration(4,32))
        let child3 = DurationNodeIntervalEnforcing(duration: Duration(13,128))
        durNode.addChild(child1)
        durNode.addChild(child2)
        durNode.addChild(child3)
        print("durNode before reduce: \(durNode)")
        durNode.reduceDurationsOfChildren()
        print("durNode after reduce: \(durNode)")
        XCTAssert(child1.duration.subdivision!.value == 128, "subdivision incorrect")
        XCTAssert(child2.duration.beats!.amount == 16, "beats incorrect")
        durNode.reduceDurationsOfChildren()
        print("durNode after second reduce: \(durNode)")
    }
    
    func testMatchDurationsOfChildren() {
        let durNode: DurationNode = DurationNodeIntervalEnforcing(duration: Duration(5,16))
        let child1 = DurationNodeIntervalEnforcing(duration: Duration(3,16))
        let child2 = DurationNodeIntervalEnforcing(duration: Duration(4,32))
        let child3 = DurationNodeIntervalEnforcing(duration: Duration(13,128))
        durNode.addChild(child1)
        durNode.addChild(child2)
        durNode.addChild(child3)
        print("durNode before matchDurationsOfChildren: \(durNode)")
        durNode.matchDurationsOfChildren()
        print("durNode after matchDurationsOfChildren: \(durNode)")
        XCTAssert(child1.duration.subdivision!.value == 128, "subdivision incorrect")
        XCTAssert(child2.duration.beats!.amount == 16, "beats incorrect")
    }
    
    func testGetMaximumSubdivisionOfSequence() {
        let dn0 = DurationNodeIntervalEnforcing(duration: Duration(1,32))
        let dn1 = DurationNodeIntervalEnforcing(duration: Duration(1,8))
        let dn2 = DurationNodeIntervalEnforcing(duration: Duration(1,64))
        let sequence: [DurationNode] = [dn0, dn1, dn2]
        let maxSubd = DurationNode.getMaximumSubdivisionOfSequence(sequence)
        XCTAssert(maxSubd! == Subdivision(value: 64), "not correct max subdivision")
    }
    
    func testGetMinimumSubdivisionOfSequence() {
        let dn0 = DurationNodeIntervalEnforcing(duration: Duration(1,32))
        let dn1 = DurationNodeIntervalEnforcing(duration: Duration(1,8))
        let dn2 = DurationNodeIntervalEnforcing(duration: Duration(1,64))
        let sequence: [DurationNode] = [dn0, dn1, dn2]
        let minSubd = DurationNode.getMinimumSubdivisionOfSequence(sequence)
        XCTAssert(minSubd! == Subdivision(value: 8), "not correct min subdivision")
    }
    
    func testGetRelativeDurationsOfSequence() {
        let dn0 = DurationNodeIntervalEnforcing(duration: Duration(1,32))
        let dn1 = DurationNodeIntervalEnforcing(duration: Duration(1,8))
        let dn2 = DurationNodeIntervalEnforcing(duration: Duration(1,64))
        let sequence: [DurationNode] = [dn0, dn1, dn2]
        let relDurs = DurationNode.getRelativeDurationsOfSequence(sequence)
        print("sequence before relDur get: \(sequence)")
        XCTAssert(relDurs == [2,8,1], "relative durations incorrect")
        print("sequence after relDur get: \(sequence)")
    }
    
    func testGetRelativeDurationsOfChildren() {
        
        /*
        let dn = DurationNode(duration: Duration(4,32))
        let dn0 = DurationNode(duration: Duration(1,32))
        let dn1 = DurationNode(duration: Duration(1,8))
        let dn2 = DurationNode(duration: Duration(1,64))
        dn.addChild(dn0)
        dn.addChild(dn1)
        dn.addChild(dn2)
        let relDurs = dn.relativeDurationsOfChildren!
        XCTAssert(relDurs == [2,8,1], "relative durations incorrect")
        */
    }
    
    func testAllSubdivisionsOfSequenceAreEquivalent() {
        let dn0 = DurationNodeIntervalEnforcing(duration: Duration(1,32))
        let dn1 = DurationNodeIntervalEnforcing(duration: Duration(1,8))
        let dn2 = DurationNodeIntervalEnforcing(duration: Duration(1,64))
        let sequence: [DurationNode] = [dn0, dn1, dn2]
        let areEquiv = DurationNode.allSubdivisionsOfSequenceAreEquivalent(sequence)
        XCTAssert(areEquiv == false, "subd equiv incorrect")
        
        let dn3 = DurationNodeIntervalEnforcing(duration: Duration(1,32))
        let dn4 = DurationNodeIntervalEnforcing(duration: Duration(1,32))
        let dn5 = DurationNodeIntervalEnforcing(duration: Duration(1,32))
        let sequence2: [DurationNode] = [dn3, dn4, dn5]
        let areEquiv2 = DurationNode.allSubdivisionsOfSequenceAreEquivalent(sequence2)
        XCTAssert(areEquiv2 == true, "subd equiv incorrect")
    }
    
    func testAddChildrenWithSequence() {
        let singleDepth = DurationNodeIntervalEnforcing(duration: Duration(5,16))
        singleDepth.addChildrenWithSequence([4,2,1])
        print("durNode with seq: \(singleDepth)")
        
        let doubleDepth = DurationNodeIntervalEnforcing(duration: Duration(5,16))
        doubleDepth.addChildrenWithSequence([[4,[3,4,2]],2,1])
        print("double depth: \(doubleDepth)")
        
        let tripleDepth = DurationNodeIntervalEnforcing(duration: Duration(5,16))
        tripleDepth.addChildrenWithSequence([[4,[2,[3,[3,1,3]]]],2,1])
        print("triple depth: \(tripleDepth)")
    }

    func testScaleDurationsOfChildren() {
        let durNode = DurationNodeIntervalEnforcing(duration: Duration(5,16), sequence: [[4,[2,2,[3,[2,3]],2]],2,1])
    }
    
    func testGetComponentTypesByPerformerID_leaf() {
        let dn = DurationNodeIntervalEnforcing(duration: Duration(1,8))
        
        // add dynamic marking component type
        let component_dm = ComponentDynamicMarking(
            performerID: "VN", instrumentID: "vn", value: "fff"
        )
        dn.addComponent(component_dm)
        XCTAssert(dn.componentTypesByPerformerID == ["VN": ["performer", "dynamics"]])
        
        // add pitch component type
        let component_p = ComponentPitch(performerID: "VC", instrumentID: "vc", values: [60.75])
        dn.addComponent(component_p)
        XCTAssert(
            dn.componentTypesByPerformerID == [
                "VN": ["performer", "dynamics"], "VC": ["performer", "pitches"]
            ]
        )

        // add dynamic component type
        let component_a = ComponentArticulation(
            performerID: "VC", instrumentID: "vc", values: ["."]
        )
        
        dn.addComponent(component_a)
        
        /*
        XCTAssert(
            dn.componentTypesByPerformerID == [
                "VN": ["performer", "dynamics"], "VC": ["performer", "pitches", "articulations"]
            ]
        )
        */
    }
    
    func testGetComponentTypesByPerformerID_container() {
        let container = DurationNodeIntervalEnforcing(duration: Duration(1,8))
        
        // create first child
        let child1 = DurationNodeIntervalEnforcing(duration: Duration(1,8))
        
        // add pitch component type
        let component_p = ComponentPitch(performerID: "VC", instrumentID: "vc", values: [60.75])
        child1.addComponent(component_p)
        
        // add child to container
        container.addChild(child1)
        
        XCTAssert(container.componentTypesByPerformerID == ["VC": ["performer", "pitches"]])
        
        // create second child
        let child2 = DurationNodeIntervalEnforcing(duration: Duration(1,16))
        
        // add dynamic component type
        let component_dm = ComponentDynamicMarking(
            performerID: "VN", instrumentID: "vn", value: "fff"
        )
        
        // add dm component
        child2.addComponent(component_dm)

        // add second child to container
        container.addChild(child2)
        
        XCTAssert(
            container.componentTypesByPerformerID == [
                "VC": ["performer", "pitches"], "VN": ["performer", "dynamics"]
            ]
        )
        
    }
    */
}