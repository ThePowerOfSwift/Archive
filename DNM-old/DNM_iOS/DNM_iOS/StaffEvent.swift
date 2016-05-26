//
//  StaffEvent.swift
//  DNM_iOS
//
//  Created by James Bean on 8/24/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit
import DNMModel

public class StaffEvent: GraphEvent {
    
    public var pitchVerticality: PitchVerticality = PitchVerticality()
    
    public var maxPitchSpelling: PitchSpelling? { get { return getMaxPitchSpelling() } }
    public var minPitchSpelling: PitchSpelling? { get { return getMinPitchSpelling() } }

    public var pitchesByNoteheadType: [NoteheadType : [Pitch]] = [:]
    
    public var amountLedgerLinesAbove: Int { return getAmountLedgerLinesAbove() }
    public var amountLedgerLinesBelow: Int { return getAmountLedgerLinesBelow() }
    
    // deprecate
    public var ledgerLines: [CAShapeLayer] = []
    
    public var noteheads: [Notehead] = []
    public var accidentals: [Accidental] = []
    
    public var staffSpaceHeight: CGFloat { return 12 * scale }
    
    public var middleCPosition: CGFloat = 0

    // deprecate
    public var gS: CGFloat { get { return staffSpaceHeight } }
    
    public override var stemEndY: CGFloat { get { return getStemEndY() } }
    
    public var clefContext: ClefContext? { return getClefContext() }
    
    public override var maxInfoY: CGFloat { get { return getMaxInfoY() } }
    public override var minInfoY: CGFloat { get { return getMinInfoY() } }
    
    public var info_yRef: CGFloat {
        get { return stemDirection == .Down ? maxInfoY : minInfoY }
    }
    
    public required init(
        identifier: GraphID = "staff",
        leaf: DurationNode,
        x: CGFloat,
        width: CGFloat,
        stemDirection: StemDirection,
        scale: Scale
    )
    {
        super.init(
            identifier: identifier,
            leaf: leaf,
            x: x,
            width: width,
            stemDirection: stemDirection,
            scale: scale
        )
    }

    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }

    public override func addComponent(component: Component) {
        switch component {
        case let componentPitch as ComponentPitch:
            componentPitch.values.forEach { addPitch(Pitch(midi: MIDI($0))) }
        default: break
        }
    }
    
    private func getClefContext() -> ClefContext? {
        return instrumentEvent?.instrument.type.clefContexts.first
    }
    
    public func addPitch(pitch: Pitch, withNoteheadType noteheadType: NoteheadType) {
        pitchVerticality.addPitch(pitch)
        if pitchesByNoteheadType[noteheadType] == nil {
            pitchesByNoteheadType[noteheadType] = [pitch]
        }
        else { pitchesByNoteheadType[noteheadType]!.append(pitch) }
    }
    
    public func addPitch(pitch: Pitch,
        respellVerticality shouldRespellVerticality: Bool = false,
        andUpdateView shouldUpdateView: Bool = false
    )
    {
        pitchVerticality.addPitch(pitch)
        
        // wrap up
        if pitchesByNoteheadType[.Ord] == nil { pitchesByNoteheadType[.Ord] = [pitch] }
        else { pitchesByNoteheadType[.Ord]!.append(pitch) }
        if shouldRespellVerticality { spellPitches() }
    }
    
    public func setMiddleCPosition(middleCPosition: CGFloat?) {
        if let mcp = middleCPosition { self.middleCPosition = mcp }
        else { self.middleCPosition = 5 * staffSpaceHeight }
    }
    
    public override func addArticulationWithType(type: ArticulationType) {
        let articulation = Articulation.withType(type, x: 0, y: 0, g: staffSpaceHeight)
        if articulation != nil { articulations.append(articulation!) }
        addSublayer(articulation!)
    }
    
    public override func build() {
        if !pitchVerticality.allPitchesHaveBeenSpelled { spellPitches() }
        setFrame()
        createNoteheads()
        createAccidentals()
        moveNoteheads()
        moveAccidentals()
        moveArticulations()
    }
    
    private func getPlacementInStaffWithY(y: CGFloat) -> PlacementInStaff {
        if abs(y) % staffSpaceHeight == 0 { return .Line }
        else if abs(y) % (0.5 * staffSpaceHeight) == 0 { return .Space }
        return .Floating
    }
    
    private func getIsWithinStaffWithY(y: CGFloat) -> Bool {
        if stemDirection == .Down && y < 4 * staffSpaceHeight { return true }
        if stemDirection == .Up && y > 0 { return true }
        return false
    }
    
    // Refactor into own class: ArticulationMover()
    internal override func moveArticulations() {
        sortArticulationsByType()
        
        // y value of highest or lowest notehead
        let yRef: CGFloat = stemDirection == .Down ? maxInfoY : minInfoY
        
        // if reference notehead is on line or in space
        let placement = getPlacementInStaffWithY(yRef)
        
        // if lines need to be avoided
        let isWithinStaff = getIsWithinStaffWithY(yRef)
        
        // direction: 1.0 or -1.0 (multiplier) of ΔY
        let dir: CGFloat = stemDirection == .Down ? 1 : -1
        
        // set initial value of y value of articulation
        let y_initial_offset = placement == .Line && isWithinStaff ? 1.5 * staffSpaceHeight * dir : staffSpaceHeight * dir
        
        // if first articulation is outside of staff, then compress, otherwise...
        let ΔY: CGFloat = getIsWithinStaffWithY(yRef + y_initial_offset) ? staffSpaceHeight : 0.75 * staffSpaceHeight
        
        // accumulate y val for each accidental
        var y = yRef + y_initial_offset
        
        // move articulations
        for articulation in articulations {
            articulation.position.y = y
            y += ΔY * dir
        }
        slurConnectionY = y
    }
    
    private func getAmountLedgerLinesAbove() -> Int {
        guard let max = maxPitchSpelling else { return 0 }
        let yMax = getYWithLetterName(max.letterName, andOctave: max.octave)
        if yMax <= -staffSpaceHeight {
            let amount = Int(floor((staffSpaceHeight - yMax) / staffSpaceHeight)) - 1
            return amount
        }
        return 0
    }
    
    private func getAmountLedgerLinesBelow() -> Int {
        guard let min = minPitchSpelling else { return 0 }
        let yMin = getYWithLetterName(min.letterName, andOctave: min.octave)
        if yMin >= 5 * staffSpaceHeight {
            let amount = -Int(floor((yMin - 4 * staffSpaceHeight) / staffSpaceHeight))
            return amount
        }
        return 0
    }

    private func createNoteheads() {
        guard pitchVerticality.allPitchesHaveBeenSpelled else { return }
        for (noteheadType, pitches) in pitchesByNoteheadType {
            for pitch in pitches {
                let s = pitch.spelling!
                let y: CGFloat = getYWithLetterName(s.letterName, andOctave: s.octave)
                createNoteheadWithType(noteheadType, atY: y)
            }
        }
    }
    
    private func createAccidentals() {
        guard pitchVerticality.allPitchesHaveBeenSpelled else { return }
        for pitch in pitchVerticality.pitches {
            let s = pitch.spelling!
            let y: CGFloat = getYWithLetterName(s.letterName, andOctave: s.octave)
            createAccidentalWithCoarse(s.coarse, andFine: s.fine, atY: y)
        }
    }
    
    private func moveNoteheads() {
        let verticality = NoteheadVerticality(noteheads: noteheads)
        let mover = NoteheadVerticalityMover(
            verticality: verticality,
            g: staffSpaceHeight,
            stemDirection: stemDirection
        )
        mover.move()
    }
    
    private func moveAccidentals() {
        let verticality = AccidentalVerticality(accidentals: accidentals)
        let mover = AccidentalVerticalityMover(
            verticality: verticality,
            staffEvent: self,
            initialOffset: -getNoteheadsMinX()
        )
        mover.move()
    }
    
    
    private func getNoteheadsMinX() -> CGFloat {
        return noteheads.map { $0.frame.minX }.minElement() ?? 0
    }
    
    public func spellPitches() {
        pitchVerticality.clearPitchSpellings()
        PitchVerticalitySpeller(verticality: pitchVerticality).spell()
    }
    
    public func createAccidentalWithCoarse(coarse: Float, andFine fine: Float, atY y: CGFloat) {
        let type = AccidentalTypeMake(coarse: coarse, fine: fine)!
        let accidental = Accidental.withType(type, x: 0, y: y, g: staffSpaceHeight, s: 1)!
        accidentals.append(accidental)
        addSublayer(accidental)
    }
    
    public func createNoteheadWithType(type: NoteheadType, atY y: CGFloat) {
        let notehead = Notehead.withType(type, x: 0, y: y, g: staffSpaceHeight, s: 1)!
        noteheads.append(notehead)
        addSublayer(notehead)
    }
    
    private func getYWithLetterName(letterName: PitchLetterName, andOctave octave: Int)
        -> CGFloat
    {
        let octaveDisplacement = 3.5 * staffSpaceHeight * CGFloat(4 - octave)
        let letterNameDisplacement = CGFloat(letterName.staffSpaces) * staffSpaceHeight
        return middleCPosition + octaveDisplacement - letterNameDisplacement
    }
    
    private func getMaxPitchSpelling() -> PitchSpelling? {
        return pitchVerticality.pitches.flatMap { $0.spelling }.maxElement()
    }
    
    private func getMinPitchSpelling() -> PitchSpelling? {
        return pitchVerticality.pitches.flatMap { $0.spelling }.minElement()
    }
    
    public override func getMaxInfoY() -> CGFloat {
        return noteheads.map { $0.position.y }.maxElement() ?? 0
    }
    
    public override func getMinInfoY() -> CGFloat {
        return noteheads.map { $0.position.y }.minElement() ?? 0
    }

    internal override func getMinY() -> CGFloat {
        let minY = sublayers?.map { $0.frame.minY }.minElement() ?? 0
        return minY > 0 ? 0 : minY
    }
    
    internal override func getMaxY() -> CGFloat {
        let maxY = sublayers?.map { $0.frame.maxY }.maxElement() ?? 0
        return maxY > 4 * staffSpaceHeight ? maxY : 4 * staffSpaceHeight
    }
    
    public override func clear() {
        super.clear()
        clearLedgerLines()
    }
    
    public func clearLedgerLines() {
        ledgerLines.forEach { $0.removeFromSuperlayer() }
    }
    
    private func getStemEndY() -> CGFloat {
        return stemDirection == .Down ? maxInfoY : minInfoY
    }
}
