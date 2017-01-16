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
        
        let staff = StaffView(clef: .treble)

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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
