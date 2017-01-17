//
//  StaffModelTests.swift
//  Staff
//
//  Created by James Bean on 1/14/17.
//
//

import XCTest
import Pitch
import PitchSpellingTools
import Staff

//class StaffModelTests: XCTestCase {
//
//    let treble = StaffClef(.treble)
//    let bass = StaffClef(.bass)
//    
//    func testCollection() {
//        
//        let positions: [Double] = [0,1,2,3,4,5]
//        let pitches: [Pitch] = [60,61,62,63,64,65]
//        let staffPoints: [StaffPointModel] = pitches.map { pitch in
//            let spelled = try! pitch.spelledWithDefaultSpelling()
//            let representable = StaffRepresentablePitch(spelled, .ord)
//            return StaffPointModel([representable])
//        }
//        
//        var model = StaffModel(clef: treble)
//        
//        zip(positions, staffPoints).forEach { position, point in
//            model.addPoint(point, at: position)
//        }
//    }
//}
