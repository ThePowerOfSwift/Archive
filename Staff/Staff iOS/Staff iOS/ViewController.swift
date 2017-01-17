//
//  ViewController.swift
//  Staff iOS
//
//  Created by James Bean on 1/12/17.
//  Copyright © 2017 James Bean. All rights reserved.
//

import UIKit
import Color
import Staff
import Pitch
import PitchSpellingTools

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pitches: [Pitch] = [60,61,62,63,64]
        let positions: [Double] = [100,150,200,250,300,350]
        let staffPoints: [StaffPointModel] = pitches.map { pitch in
            let spelled = try! pitch.spelledWithDefaultSpelling()
            let representable = StaffRepresentablePitch(spelled, .ord)
            return StaffPointModel([representable])
        }
        
        var model = StaffModel(clef: StaffClef(.treble))
        zip(positions, staffPoints).forEach { position, point in
            model.addPoint(point, at: position)
        }
        
        let staffView = StaffView(model: model)
        view.layer.addSublayer(staffView)
        
        /*
        let staff = StaffView(model: model)

        staff.position.x += 100
        staff.position.y += 100
        
        view.layer.addSublayer(staff)
        view.layer.backgroundColor = Color(gray: 0, alpha: 1).cgColor
        
        
        let flat = Accidental.makeAccidental(withKind: .flat, point: CGPoint(x: 400, y: 400), staffSlotHeight: 20)
        view.layer.addSublayer(flat)
        
        let notehead = Notehead(point: CGPoint(x: 200, y: 200), staffSlotHeight: 20)
        view.layer.addSublayer(notehead)
        
        let spelledPitch = SpelledPitch(60, PitchSpelling(.c))
        let representable = StaffRepresentablePitch(spelledPitch)
        
        let represented = StaffRepresentedPitch(representableContext: representable, altitude: 0, staffSlotHeight: 20)
        
        staff.addSublayer(represented.accidental)
        staff.addSublayer(represented.notehead)
        
        represented.accidental.position.x -= 30
        
        print(representable)
        */
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
