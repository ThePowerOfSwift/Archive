//
//  PitchDyadSpeller.swift
//  DNMModel
//
//  Created by James Bean on 8/12/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

/**
Spells PitchDyads
*/
public class PitchDyadSpeller {
    
    // MARK: String Representation
    
    /// Printed description of PitchSpellerDyad
    public var description: String = "PitchSpellerDyad"
    
    // MARK: Attributes
    
    /// PitchDyad spelled by PitchSpellerDyad
    public var dyad: PitchDyad
    
    public var bothPitchesHaveBeenSpelled: Bool {
        return getBothPitchesHaveBeenSpelled() }
    
    public var onePitchHasBeenSpelled: Bool {
        return getOnePitchHasBeenSpelled()
    }
    
    public var neitherPitchHasBeenSpelled: Bool {
        return getNeitherPitchHasBeenSpelled()
    }
    
    public var canBeSpelledObjectively: Bool {
        return getCanBeSpelledObjectively()
    }
    
    /// All possible PitchSpelling combinations for PitchDyad
    public var allPSDyads: [PitchSpellingDyad] { return getAllPSDyads() }
    
    /// All PitchSpellingDyads that preserve interval quality properly
    public var stepPreserving: [PitchSpellingDyad] { return getStepPreserving() }
    
    /// All PitchSpellingDyads that preserve fine direction (1/8th-tone arrow direction)
    public var fineMatching: [PitchSpellingDyad] { return getFineMatching() }
    
    /// All PitchSpellingDyads that preserve coarse (flat == flat, quarterFlat != flat)
    public var coarseMatching: [PitchSpellingDyad] { return getCoarseMatching() }
    
    /// All PitchSpellingDyads that preserve coarse direction (sharp == quarterSharp)
    public var coarseDirectionMatching: [PitchSpellingDyad] {
        return getCoarseDirectionMatching()
    }
    
    /// All PitchSpellingDyads that preserve coarse resolution (sharp == flat, sharp != qsharp)
    public var coarseResolutionMatching: [PitchSpellingDyad] {
        return getCoarseResolutionMatching()
    }
    
    /**
    In the case of pitches with an 1/8th-tone resolution (0.25), prevailingFine is used to
    ensure same fine direction for both pitches in dyad (if necessary)
    */
    public var prevailingFine: Float?
    
    // MARK: Spelling with desired properties
    
    /**
    Fine value desired (in the context of a PitchVerticality, if other pitches require a
    specific fine value)
    */
    public var desiredFine: Float?
    
    /**
    Coarse direction value desired (in the context of a PitchVerticality, if other pitches 
    require a specific coarse direction)
    */
    public var desiredCoarseDirection: Float?
    
    /**
    Coarse resolution value desired (in the context of a PitchVerticality, if other pitches
    require a specific coarse coarse resolution)
    */
    public var desiredCoarseResolution: Float?
    
    /**
    Create a PitchDyadSpeller with a PitchDyad (pair of Pitches)

    - parameter dyad: Pair of Pitches

    - returns: PitchDyadSpeller
    */
    public init(dyad: PitchDyad) {
        self.dyad = dyad
    }
    
    /**
    Spell with a desired fine value

    - parameter fine: Fine value (1/8th-tone direction (0, 0.25, -0.25))
    */
    public func spellWithDesiredFine(fine: Float) {
        self.desiredFine = fine
        spell()
    }
    
    /**
    Spell with a desired coarse direction value

    - parameter coarseDirection: Coarse direction value (0, 1, -1)
    */
    public func spellWithDesiredCoarseDirection(coarseDirection: Float) {
        self.desiredCoarseDirection = coarseDirection
        spell()
    }
    
    /**
    Spell with a desired coarse resolution value

    - parameter coarseResolution: Coarse resolution value (0.5, 1)
    */
    public func spellWithDesiredCoarseResolution(coarseResolution: Float) {
        self.desiredCoarseResolution = coarseResolution
        spell()
    }
    
    /**
    Spell the pitches of the Dyad. If this PitchDyadSpeller is NOT being used within a
    PitchVerticalitySpeller (which, probably shouldn't happen -- but for testing purposes,
    this is left as a possibility), set shouldSpellPitchesObjectively to true. This will
    automatically set the PitchSpelling for Pitches that have a single possible PitchSpelling.
    Same thing with mustSpellBothPitches, this will be cleaned up higher in the chain when
    using a PitchVerticalitySpeller, but use it for testing

    - parameter mustSpellBothPitches:          Must spell both Pitches in Dyad
    - parameter shouldSpellPitchesObjectively: Spell pitches with only one pitch spelling
    */
    public func spell(
        enforceBothPitchesSpelled mustSpellBothPitches: Bool = false,
        spellPitchesObjectively shouldSpellPitchesObjectively: Bool = false
    )
    {
        if shouldSpellPitchesObjectively { spellPitchesObjectivelyIfPossible() }

        if bothPitchesHaveBeenSpelled {
            //print("both have been spelled")
            /* pass */
        }
        else if neitherPitchHasBeenSpelled {
            neitherSpelled()
        }
        else if onePitchHasBeenSpelled {
            oneSpelled()
        }
        
        // set default values to pitches if there's just no other solution
        if mustSpellBothPitches {
            for pitch in [dyad.pitch0, dyad.pitch1] {
                if !pitch.hasBeenSpelled {
                    pitch.setPitchSpelling(pitch.possibleSpellings.first!)
                }
            }
        }
    }
    
    // make private?
    public func oneSpelled() {
        guard onePitchHasBeenSpelled else { return }
        
        // get spelled pitch
        let unspelled: Pitch = dyad.pitch0.hasBeenSpelled ? dyad.pitch1 : dyad.pitch0
        
        // get unspelled pitch
        let spelled: Pitch = dyad.pitch0.hasBeenSpelled ? dyad.pitch0 : dyad.pitch1
        
        // orient self around resolution of spelled pitch
        switch spelled.resolution {
        case 0.50: oneSpelledQuarterTone(spelled: spelled, unspelled: unspelled)
        case 0.25: oneSpelledEighthTone(spelled: spelled, unspelled: unspelled)
        default: oneSpelledHalfTone(spelled: spelled, unspelled: unspelled)
        }
    }
    
    // make private
    public func oneSpelledHalfTone(spelled spelled: Pitch, unspelled: Pitch) {
        // filter step preserving to include more-global fine-match: encapsulate
        if desiredFine != nil && unspelled.resolution == 0.25 {
            //sp = filterPSDyadsToIncludeDesiredFineMatching(sp)
            let all = filterPSDyadsToIncludeCurrentlySpelled(allPSDyads)
            let dfm = filterPSDyadsToIncludeDesiredFineMatching(all)
            switch dfm.count {
            case 0:
                break
            case 1:
                let spelling = getSpellingForUnspelledFromPSDyad(dfm.first!)
                spellPitch(unspelled, withSpelling: spelling)
                
            default:
                let sp = intersection(dfm, array1: stepPreserving)
                switch sp.count {
                case 0:
                    break
                case 1:
                    let spelling = getSpellingForUnspelledFromPSDyad(sp.first!)
                    spellPitch(unspelled, withSpelling: spelling)
                    break
                default:
                    break
                }
            }
        }
        else {
            let sp = filterPSDyadsToIncludeCurrentlySpelled(stepPreserving)
            switch sp.count {
            case 0:
                //print("none sp: big trouble")
                let crm = filterPSDyadsToIncludeCurrentlySpelled(coarseResolutionMatching)
                switch crm.count {
                case 0:
                    //print("none crm: really big trouble")
                    break
                case 1:
                    //print("one crm")
                    let spelling = getSpellingForUnspelledFromPSDyad(crm.first!)
                    spellPitch(unspelled, withSpelling: spelling)
                default:
                    //print("more than one crm")
                    let leastMeanSharp = getLeastMeanSharp(crm)
                    let spelling = getSpellingForUnspelledFromPSDyad(leastMeanSharp)
                    spellPitch(unspelled, withSpelling: spelling)
                }
            case 1:
                //print("one sp: spell")
                let spelling = getSpellingForUnspelledFromPSDyad(sp.first!)
                spellPitch(unspelled, withSpelling: spelling)
            default:
                //print("more than one sp")
                let sp_crm = intersection(sp, array1: coarseResolutionMatching)
                switch sp_crm.count {
                case 1:
                    //print("one sp_crm")
                    let spelling = getSpellingForUnspelledFromPSDyad(sp_crm.first!)
                    spellPitch(unspelled, withSpelling: spelling)
                    break
                default:
                    //print("more than one sp_crm")
                    let leastMeanSharp = getLeastMeanSharp(sp)
                    let spelling = getSpellingForUnspelledFromPSDyad(leastMeanSharp)
                    spellPitch(unspelled, withSpelling: spelling)
                }
            }
        }
    }
    
    // make private
    public func oneSpelledQuarterTone(spelled spelled: Pitch, unspelled: Pitch) {
        
        // filter step preserving to include more-global fine-match: encapsulate
        if desiredFine != nil && unspelled.resolution == 0.25 {
            //sp = filterPSDyadsToIncludeDesiredFineMatching(sp)
            let all = filterPSDyadsToIncludeCurrentlySpelled(allPSDyads)
            let dfm = filterPSDyadsToIncludeDesiredFineMatching(all)
            switch dfm.count {
            case 0:
                break
            case 1:
                let spelling = getSpellingForUnspelledFromPSDyad(dfm.first!)
                spellPitch(unspelled, withSpelling: spelling)
            default:
                let sp = intersection(dfm, array1: stepPreserving)
                switch sp.count {
                case 0:
                    break
                case 1:
                    let spelling = getSpellingForUnspelledFromPSDyad(sp.first!)
                    spellPitch(unspelled, withSpelling: spelling)
                    break
                default:
                    break
                }
            }
        }
            
            // IF NO MORE-GLOBAL FINE MATCH REQUIRED
            
        else {
            let sp = filterPSDyadsToIncludeCurrentlySpelled(stepPreserving)
            switch sp.count {
            case 0:
                //print("none step preserving: big trouble")
                //let spelling = getLeastSharp(GetPitchSpellings.forPitch(unspelled))
                let spelling = getLeastSharp(PitchSpelling.pitchSpellingsForPitch(pitch: unspelled))
                spellPitch(unspelled, withSpelling: spelling)
            case 1:
                //print("one step preserving: spell")
                let spelling = getSpellingForUnspelledFromPSDyad(sp.first!)
                spellPitch(unspelled, withSpelling: spelling)
            default:
                //print("more than one step preserving")
                let sp_cdm = intersection(sp, array1: coarseDirectionMatching)
                switch sp_cdm.count {
                case 0:
                    //print("none sp_cdm")
                    let leastMeanSharp = getLeastMeanSharp(sp)
                    let spelling = getSpellingForUnspelledFromPSDyad(leastMeanSharp)
                    spellPitch(unspelled, withSpelling: spelling)
                case 1:
                    //print("one sp_cdm: spell")
                    let spelling = getSpellingForUnspelledFromPSDyad(sp_cdm.first!)
                    spellPitch(unspelled, withSpelling: spelling)
                default:
                    //print("more than one sp_cdm")
                    let sp_cdm_crm = intersection(sp_cdm, array1: coarseResolutionMatching)
                    switch sp_cdm_crm.count {
                    case 0:
                        //print("none sp_cdm_crm")
                        break
                    case 1:
                        //print("one sp_cdm_crm")
                        let spelling = getSpellingForUnspelledFromPSDyad(sp_cdm_crm.first!)
                        spellPitch(unspelled, withSpelling: spelling)
                    default:
                        //print("more than one sp_cdm_crm")
                        break
                    }
                }
            }
        }
        
    }
    
    // make private
    public func oneSpelledEighthTone(spelled spelled: Pitch, unspelled: Pitch) {
        prevailingFine = spelled.spelling!.fine
        
        switch unspelled.resolution {
            
        // UNSPELLED HAS 1/8th-tone RESOLUTION
        case 0.25:
            let fm = filterPSDyadsToIncludeCurrentlySpelled(fineMatching)
            switch fm.count {
            case 0:
                //print("none fine matching: big trouble)")
                break
            case 1:
                //print("one fine matching: spell")
                let spelling = getSpellingForUnspelledFromPSDyad(fm.first!)
                spellPitch(unspelled, withSpelling: spelling)
            default:
                //print("more than one fine matching")
                let fm_sp = intersection(fm, array1: stepPreserving)
                switch fm_sp.count {
                case 0:
                    //print("none fm_sp: get least mean sharp of fm")
                    let leastMeanSharp = getLeastMeanSharp(fm)
                    let spelling = getSpellingForUnspelledFromPSDyad(leastMeanSharp)
                    spellPitch(unspelled, withSpelling: spelling)
                case 1:
                    //print("one fm_sp: spell")
                    let spelling = getSpellingForUnspelledFromPSDyad(fm_sp.first!)
                    spellPitch(unspelled, withSpelling: spelling)
                default:
                    //print("more than one fm_sp")
                    let fm_sp_cdm = intersection(fm_sp, array1: coarseDirectionMatching)
                    switch fm_sp_cdm.count {
                    case 0:
                        //print("none fm_sp_cdm")
                        let leastMeanSharp = getLeastMeanSharp(fm_sp)
                        let spelling = getSpellingForUnspelledFromPSDyad(leastMeanSharp)
                        spellPitch(unspelled, withSpelling: spelling)
                    case 1:
                        //print("one fm_sp_cdm: spell")
                        let spelling = getSpellingForUnspelledFromPSDyad(fm_sp_cdm.first!)
                        spellPitch(unspelled, withSpelling: spelling)
                    default:
                        //print("more than one fm_sp_cdm")
                        let leastMeanSharp = getLeastMeanSharp(fm_sp_cdm)
                        let spelling = getSpellingForUnspelledFromPSDyad(leastMeanSharp)
                        spellPitch(unspelled, withSpelling: spelling)
                    }
                }
            }
            
        // UNSPELLED HAS A 1/4 or 1/2-tone RESOLUTION
        default:
            //print("unspelled does not have 1/8th-tone resolution")
            let sp = filterPSDyadsToIncludeCurrentlySpelled(stepPreserving)
            switch sp.count {
            case 0:
                //print("none sp")
                let cdm = filterPSDyadsToIncludeCurrentlySpelled(coarseDirectionMatching)
                let spelling = getSpellingForUnspelledFromPSDyad(cdm.first!)
                spellPitch(unspelled, withSpelling: spelling)
            case 1:
                //print("one sp")
                let spelling = getSpellingForUnspelledFromPSDyad(sp.first!)
                spellPitch(unspelled, withSpelling: spelling)
            default:
                //print("more than one sp")
                let sp_cdm = intersection(sp, array1: coarseDirectionMatching)
                switch sp_cdm.count {
                case 0:
                    //print("none sp_cdm")
                    let leastMeanSharp = getLeastMeanSharp(sp)
                    let spelling = getSpellingForUnspelledFromPSDyad(leastMeanSharp)
                    spellPitch(unspelled, withSpelling: spelling)
                case 1:
                    //print("one sp_cdm")
                    let spelling = getSpellingForUnspelledFromPSDyad(sp_cdm.first!)
                    spellPitch(unspelled, withSpelling: spelling)
                default:
                    //print("more than one sp_cdm")
                    let sp_cdm_crm = intersection(sp_cdm, array1: coarseResolutionMatching)
                    switch sp_cdm_crm.count {
                    case 0:
                        //print("none sp_cdm_crm")
                        let leastMeanSharp = getLeastMeanSharp(sp_cdm)
                        let spelling = getSpellingForUnspelledFromPSDyad(leastMeanSharp)
                        spellPitch(unspelled, withSpelling: spelling)
                    case 1:
                        //print("one sp_cdm_crm: spell")
                        let spelling = getSpellingForUnspelledFromPSDyad(sp_cdm_crm.first!)
                        spellPitch(unspelled, withSpelling: spelling)
                    default:
                        //print("more than one sp_cdm_crm")
                        let leastMeanSharp = getLeastMeanSharp(sp_cdm_crm)
                        let spelling = getSpellingForUnspelledFromPSDyad(leastMeanSharp)
                        spellPitch(unspelled, withSpelling: spelling)
                    }
                }
            }
        }
    }
    
    // make private
    public func neitherSpelled() {
        
        // ENCAPSULATE
        
        if dyad.pitch0.resolution == 1 && dyad.pitch1.resolution == 1 {
            var spellings: [PitchSpelling] = []
            
            for spelling in PitchSpelling.pitchSpellingsForPitch(pitch: dyad.pitch0) {
                spellings.append(spelling)
            }
            for spelling in PitchSpelling.pitchSpellingsForPitch(pitch: dyad.pitch1) {
                spellings.append(spelling)
            }
            
            
            let leastSharp = getLeastSharp(spellings)
            spellPitch(leastSharp.pitch, withSpelling: leastSharp)
            oneSpelled()
        }
            
            // ENCAPSULATE
        else if desiredFine != nil {
            for pitch in [dyad.pitch0, dyad.pitch1] {
                //print(pitch)
                for spelling in PitchSpelling.pitchSpellingsForPitch(pitch: pitch) {
                    if spelling.fine == desiredFine! {
                        //print("FINE MATCH")
                        spellPitch(pitch, withSpelling: spelling)
                        if onePitchHasBeenSpelled { oneSpelled() }
                        break
                    }
                }
                
                // DEPRECATED
                /*
                for spelling in GetPitchSpellings.forPitch(pitch) {
                    print(spelling)
                    if spelling.fine == desiredFine! {
                        //print("FINE MATCH")
                        spellPitch(pitch, withSpelling: spelling)
                        if onePitchHasBeenSpelled { oneSpelled() }
                        break
                    }
                }
                */
            }
        }
            
            
        // ENCAPSULATE
            
        else {
            var containsNaturalSpelling: Bool = false
            for pitch in [dyad.pitch0, dyad.pitch1] {
                //for spelling in GetPitchSpellings.forPitch(pitch) {
                for spelling in PitchSpelling.pitchSpellingsForPitch(pitch: pitch) {
                    if spelling.coarse == 0.0 {
                        spellPitch(pitch, withSpelling: spelling)
                        containsNaturalSpelling = true
                        break
                    }
                }
                break
            }
            
            // ENCAPSULATE
            
            if containsNaturalSpelling { if onePitchHasBeenSpelled { oneSpelled() } }
            else {
                var containsFlatOrSharpSpelling: Bool = false
                for pitch in [dyad.pitch0, dyad.pitch1] {
                    
                    //for spelling in GetPitchSpellings.forPitch(pitch) {
                    
                    for spelling in PitchSpelling.pitchSpellingsForPitch(pitch: pitch) {
                        if spelling.coarseResolution == 1.0 {
                            spellPitch(pitch, withSpelling: spelling)
                            containsFlatOrSharpSpelling = true
                            break
                        }
                    }
                    break
                }
                
                // ENCAPSULATE
                
                if containsFlatOrSharpSpelling {
                    //print("contains flat or sharp spelling")
                    
                    if onePitchHasBeenSpelled { oneSpelled() }
                    
                    else {
                        
                        //print("still no pitches spelled")
                        
                        // get spelling with least sharp
                        var dyads: [PitchSpellingDyad] = []
                        
                        //for ps0 in GetPitchSpellings.forPitch(dyad.pitch0) {
                        
                        for ps0 in PitchSpelling.pitchSpellingsForPitch(pitch: dyad.pitch0) {
                            
                            //for ps1 in GetPitchSpellings.forPitch(dyad.pitch1) {
                            
                            for ps1 in PitchSpelling.pitchSpellingsForPitch(pitch: dyad.pitch1) {
                            
                                let dyad = PitchSpellingDyad(ps0: ps0, ps1: ps1)
                                dyads.append(dyad)
                            }
                        }
                        let leastMeanSharp = getLeastMeanSharp(dyads)
                        spellPitch(dyad.pitch0, withSpelling: leastMeanSharp.pitchSpelling0)
                        spellPitch(dyad.pitch1, withSpelling: leastMeanSharp.pitchSpelling1)
                    }
                }
                else {
                    // this only happens if both pitches are 1/4 tone pitches: 4.5 / 11.5
                    
                    //for spelling in GetPitchSpellings.forPitch(dyad.pitch0) {
                    
                    for spelling in PitchSpelling.pitchSpellingsForPitch(pitch: dyad.pitch0) {
                        if spelling.coarse == 0.5 {
                            spellPitch(dyad.pitch0, withSpelling: spelling)
                            break
                        }
                    }
                    if onePitchHasBeenSpelled { oneSpelled() }
                }
            }
        }
    }
    
    private func filterPSDyadsToIncludeCurrentlySpelled(psDyads: [PitchSpellingDyad])
        -> [PitchSpellingDyad]
    {
        assert(onePitchHasBeenSpelled, "one pitch must be spelled")
        if dyad.pitch0.hasBeenSpelled {
            return psDyads.filter { $0.pitchSpelling0 == self.dyad.pitch0.spelling! }
        }
        else {
            return psDyads.filter { $0.pitchSpelling1 == self.dyad.pitch1.spelling! }
        }
    }
    
    private func filterPSDyadsToIncludeDesiredFineMatching(psDyads: [PitchSpellingDyad])
        -> [PitchSpellingDyad]
    {
        assert(desiredFine != nil, "desiredFine must be set for this to work")
        var psDyads = psDyads
        if dyad.pitch0.resolution == 0.25 {
            psDyads =  psDyads.filter { $0.pitchSpelling0.fine == self.desiredFine! }
        }
        else { psDyads = psDyads.filter { $0.pitchSpelling1.fine == self.desiredFine! } }
        return psDyads
    }
    
    public func spellPitchesObjectivelyIfPossible() {
        for pitch in [dyad.pitch0, dyad.pitch1] {
            if PitchSpelling.pitchSpellingsForPitch(pitch: pitch).count == 1 {
                let spelling = PitchSpelling.pitchSpellingsForPitch(pitch: pitch).first!
                pitch.setPitchSpelling(spelling)
            }
        }
    }
    
    private func getCanBeSpelledObjectively() -> Bool {
        let pitch0_count = PitchSpelling.pitchSpellingsForPitch(pitch: dyad.pitch0).count
        let pitch1_count = PitchSpelling.pitchSpellingsForPitch(pitch: dyad.pitch1).count
        return pitch0_count == 1 && pitch1_count == 1
    }
    
    private func getBothPitchesHaveBeenSpelled() -> Bool {
        return dyad.pitch0.hasBeenSpelled && dyad.pitch1.hasBeenSpelled
    }
    
    private func getOnePitchHasBeenSpelled() -> Bool {
        return (
            dyad.pitch0.hasBeenSpelled && !dyad.pitch1.hasBeenSpelled ||
                dyad.pitch1.hasBeenSpelled && !dyad.pitch0.hasBeenSpelled
        )
    }
    
    private func getNeitherPitchHasBeenSpelled() -> Bool {
        return !dyad.pitch0.hasBeenSpelled && !dyad.pitch1.hasBeenSpelled
    }
    
    public func getCoarseMatching() -> [PitchSpellingDyad] {
        var coarseMatching: [PitchSpellingDyad] = []
        for ps0 in PitchSpelling.pitchSpellingsForPitch(pitch: dyad.pitch0) {
            for ps1 in PitchSpelling.pitchSpellingsForPitch(pitch: dyad.pitch1) {
                let psDyad = PitchSpellingDyad(ps0: ps0, ps1: ps1)
                if psDyad.isCoarseMatching { coarseMatching.append(psDyad) }
            }
        }
        return coarseMatching
    }
    
    public func getCoarseResolutionMatching() -> [PitchSpellingDyad] {
        var coarseResolutionMatching: [PitchSpellingDyad] = []
        for ps0 in PitchSpelling.pitchSpellingsForPitch(pitch: dyad.pitch0) {
            for ps1 in PitchSpelling.pitchSpellingsForPitch(pitch: dyad.pitch1) {
                let psDyad = PitchSpellingDyad(ps0: ps0, ps1: ps1)
                if psDyad.isCoarseResolutionMatching { coarseResolutionMatching.append(psDyad) }
            }
        }
        return coarseResolutionMatching
    }
    
    public func getCoarseDirectionMatching() -> [PitchSpellingDyad] {
        var coarseDirectionMatching: [PitchSpellingDyad] = []
        
        for ps0 in PitchSpelling.pitchSpellingsForPitch(pitch: dyad.pitch0) {
            for ps1 in PitchSpelling.pitchSpellingsForPitch(pitch: dyad.pitch1) {
                let psDyad = PitchSpellingDyad(ps0: ps0, ps1: ps1)
                if psDyad.isCoarseDirectionMatching { coarseDirectionMatching.append(psDyad) }
            }
        }
        return coarseDirectionMatching
    }
    
    public func getFineMatching() -> [PitchSpellingDyad] {
        var fineMatching: [PitchSpellingDyad] = []

        for ps0 in PitchSpelling.pitchSpellingsForPitch(pitch: dyad.pitch0) {
            for ps1 in PitchSpelling.pitchSpellingsForPitch(pitch: dyad.pitch1) {
                let psDyad = PitchSpellingDyad(ps0: ps0, ps1: ps1)
                if psDyad.isFineMatching { fineMatching.append(psDyad) }
            }
        }
        return fineMatching
    }
    
    public func getStepPreserving() -> [PitchSpellingDyad] {
        var stepPreserving: [PitchSpellingDyad] = []
        
        for ps0 in PitchSpelling.pitchSpellingsForPitch(pitch: dyad.pitch0) {
            for ps1 in PitchSpelling.pitchSpellingsForPitch(pitch: dyad.pitch1) {
                let psDyad = PitchSpellingDyad(ps0: ps0, ps1: ps1)
                if psDyad.isStepPreserving { stepPreserving.append(psDyad) }
            }
        }
        return stepPreserving
    }
    
    private func getAllPSDyads() -> [PitchSpellingDyad] {
        var allPSDyads: [PitchSpellingDyad] = []
        
        for ps0 in PitchSpelling.pitchSpellingsForPitch(pitch: dyad.pitch0) {
            for ps1 in PitchSpelling.pitchSpellingsForPitch(pitch: dyad.pitch1) {
                let psDyad = PitchSpellingDyad(ps0: ps0, ps1: ps1)
                allPSDyads.append(psDyad)
            }
        }
        return allPSDyads
    }
    
    private func getSpellingForUnspelledFromPSDyad(psDyad: PitchSpellingDyad)
        -> PitchSpelling
    {
        // manage this better
        assert(onePitchHasBeenSpelled, "one pitch must be spelled")
        
        return dyad.pitch0.hasBeenSpelled ? psDyad.pitchSpelling1 : psDyad.pitchSpelling0
    }
    
    private func getLeastMeanSharp(psDyads: [PitchSpellingDyad]) -> PitchSpellingDyad {
        var leastMeanSharp: PitchSpellingDyad?
        for psDyad in psDyads {
            if leastMeanSharp == nil { leastMeanSharp = psDyad }
            else if abs(psDyad.meanSharpness) < abs(leastMeanSharp!.meanSharpness) {
                leastMeanSharp = psDyad
            }
        }
        return leastMeanSharp!
    }
    
    private func getLeastSharp(pitchSpellings: [PitchSpelling]) -> PitchSpelling {
        var leastSharp: PitchSpelling?
        for pitchSpelling in pitchSpellings {
            if leastSharp == nil { leastSharp = pitchSpelling }
            else if abs(pitchSpelling.sharpness) < abs(leastSharp!.sharpness) {
                leastSharp = pitchSpelling
            }
        }
        return leastSharp!
    }
    
    private func spellPitch(unspelled: Pitch, withSpelling spelling: PitchSpelling) {
        unspelled.setPitchSpelling(spelling)
        if spelling.fine != 0 { prevailingFine = spelling.fine }
    }
}
