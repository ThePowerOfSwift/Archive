//
//  ScoreViewTests.swift
//  DNM_iOS
//
//  Created by James Bean on 12/16/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import XCTest
import DNMModel

class ScoreViewTests: XCTestCase {

    func testInit() {
        let scoreModel = makeScoreModel()
        let profile = ViewerProfile(allViewers: [ViewerOmni], currentViewer: ViewerOmni)
        let scoreViewModel = ScoreViewModel(scoreModel: scoreModel, viewerProfile: profile)
        print(scoreViewModel)
    }
    
    func makeScoreModel() -> ScoreModel {
        
        var scoreModel = ScoreModel()
        
        let measures = [
            MeasureModel(duration: Duration(3,16), offsetDuration: DurationZero),
            MeasureModel(duration: Duration(5,16), offsetDuration: Duration(3,16))
        ]
        
        let dn0 = DurationNode(duration: Duration(3,16), sequence: [1])
        
        (dn0.children.first as! DurationNode).addComponent(
            ComponentPitch(performerID: "VC", instrumentID: "vc", values: [60])
        )
        
        let dn1 = DurationNode(
            duration: Duration(5,16), offsetDuration: Duration(3,16), sequence: [1,1,1,1,1]
        )
        
        for leaf in dn1.leaves as! [DurationNode] {
            leaf.addComponent(
                ComponentDynamicMarking(performerID: "VC", instrumentID: "vc", value: "fff")
            )
        }
        
        let dn2 = DurationNode(duration: Duration(4,16), offsetDuration: DurationZero, sequence: [1,1,1,1])
        
        for leaf in dn2.leaves as! [DurationNode] {
            leaf.addComponent(
                ComponentPitch(performerID: "VN", instrumentID: "vn", values: [60, 80, 90])
            )
        }
        
        scoreModel.measures = measures
        scoreModel.durationNodes = [dn0, dn1, dn2]
        return scoreModel
    }

}
