
/**
Dyad: Pair of Pitches
*/
class Dyad {
    
    let pitchSpellingsByPitchClass = PitchSpellingsByIntervalPitchClass.sharedInstance
    
    // MARK: Pitches
    
    /// Lower of two pitches
    var pitch0: Pitch
    
    /// Higher of two pitches
    var pitch1: Pitch
    
    // MARK: Analysis
    
    /// Interval between two pitches
    var interval: Float { get { return abs(pitch0.midi - pitch1.midi) % 12.0 } }
    
    /// Complexity of Interval between two pitches
    var complexity: Int { get { return getIntervalComplexityByIntervalPitchClass() } }
    
    // MARK: Spelling of Pitches in Dyad
    
    /// All potential combinations of pairs of PitchSpellings
    var pitchSpellingCombinations: [(PitchSpelling, PitchSpelling)] = []
    
    /// Chosen spellings for both Pitches in Dyad
    var pitchSpellings: (PitchSpelling, PitchSpelling)?
    
    /// If Dyad has been spelled
    var hasBeenSpelled: Bool { get { return pitchSpellings != nil } }
    
    /// If an attempt has been made to spell Dyad
    var spellingHasBeenAttempted: Bool {
        get { return pitchSpellingCombinations.count > 0 && !hasBeenSpelled }
    }
    
    // MARK: PitchSpelling Combinations Preserving Preferences
    
    /// Collection of pairs of PitchSpellings that preserve step
    var stepPreserving: [[PitchSpelling]] = []
    
    /// Collection of pairs of PitchSpellings that match fine direction (arrow up / down)
    var fineMatching: [[PitchSpelling]] = []
    
    /// Collection of pairs of PitchSpellings that match coarse value (flat, quarterSharp, etc)
    var coarseMatching: [[PitchSpelling]] = []
    
    /// Collection of pairs of PitchSpellings that match coarseDirection (sharp, quarterSharp, etc)
    var coarseDirectionMatching: [[PitchSpelling]] = []
    
    /// Collection of pairs of PitchSpellings that match coarseResolution (sharp, flat, etc)
    var coarseResolutionMatching: [[PitchSpelling]] = []
    
    // MARK: Create a Dyad
    
    /**
    Create a Dyad with two pitches
    
    :param: pitch0 Pitch
    :param: pitch1 Pitch
    
    :returns: Self: Dyad
    */
    init(pitch0: Pitch, pitch1: Pitch) {
        var pitches: [Pitch] = [pitch0, pitch1]; pitches.sort { $0.midi < $1.midi }
        self.pitch0 = pitches[0]
        self.pitch1 = pitches[1]
    }
    
    /**
    Spell Dyad
    */
    func spell() {
        
        // call PitchSpeller(verticality: Dyad)
        
        buildPreferenceArrays()
        setPitchSpellingsIfPitchesCanBeSpelledObjectively()
        if pitch0.hasBeenSpelled && pitch1.hasBeenSpelled { /* pass */ }
        else if pitch0.hasBeenSpelled || pitch1.hasBeenSpelled { oneSpelled() }
        else { neitherSpelled() }
    }
    
    
    // ALL OF THIS SHIT NEEDS TO BE MOVED TO PITCH SPELLER!!!!!
    
    // func spell(#fine: Float) {}
    
    // func spell(#coarse: Float) {}
    
    private func oneSpelled() {
        let (spelled, unspelled) = setSpelledAndUnspelled()
        
        // spelled is natural
        if spelled.spelling!.coarse == 0 && spelled.spelling!.fine == 0 {
            spelledIsNatural(spelled: spelled, unspelled: unspelled)
        }
        else if spelled.spelling!.coarse == 0 && spelled.spelling!.fine != 0 {
            spelledIsNaturalUpOrDown(spelled: spelled, unspelled: unspelled)
        }
        // (qtr) sharp or (qtr) flat
        else if spelled.spelling!.coarseResolution != 0 && spelled.spelling!.fine == 0 {
            spelledIsAltered(spelled: spelled, unspelled: unspelled)
        }
        // quarterSharp or quarterFlat up / down
        else if spelled.spelling!.coarseResolution != 0 && spelled.spelling!.fine != 0 {
            spelledIsAlteredUpOrDown(spelled: spelled, unspelled: unspelled)
        }
        else {
            println("something else?")
        }
    }
    
    private func neitherSpelled() {
        if pitch0.resolution == 0.25 && pitch1.resolution == 0.25 {
            switch fineMatching.count {
            case 0:
                println("we are fucked, i think this is impossible though")
            case 1:
                let pair = fineMatching[0]
                spellPitchesWithSpellingPair(pair)
            default:
                let fineMatchIntersectCoarseMatch = intersection(
                    array0: fineMatching,
                    array1: coarseMatching
                )
                switch fineMatchIntersectCoarseMatch.count {
                case 0:
                    let fineMatchIntersectCoarseResMatch = intersection(
                        array0: fineMatching,
                        array1: coarseResolutionMatching
                    )
                    switch fineMatchIntersectCoarseResMatch.count {
                    case 0:
                        let fineMatchIntersectCoarseDirMatch = intersection(
                            array0: fineMatching,
                            array1: coarseDirectionMatching
                        )
                        switch fineMatchIntersectCoarseDirMatch.count {
                        case 0:
                            let pair = getLeastMeanSharpness(fineMatching)
                            spellPitchesWithSpellingPair(pair)
                        case 1:
                            let pair = fineMatchIntersectCoarseDirMatch[0]
                            spellPitchesWithSpellingPair(pair)
                        default:
                            let pair = getLeastMeanSharpness(fineMatchIntersectCoarseDirMatch)
                            spellPitchesWithSpellingPair(pair)
                        }
                    case 1:
                        let pair = fineMatchIntersectCoarseResMatch[0]
                        spellPitchesWithSpellingPair(pair)
                    default:
                        let pair = getLeastMeanSharpness(fineMatchIntersectCoarseResMatch)
                        spellPitchesWithSpellingPair(pair)
                    }
                case 1:
                    let pair = fineMatchIntersectCoarseMatch[0]
                    spellPitchesWithSpellingPair(pair)
                default:
                    let pair = getLeastMeanSharpness(fineMatchIntersectCoarseMatch)
                    spellPitchesWithSpellingPair(pair)
                }
            }
        }
        else {
            switch coarseMatching.count {
            case 0:
                switch coarseResolutionMatching.count {
                case 0:
                    let pair = getLeastMeanSharpness(coarseDirectionMatching)
                    spellPitchesWithSpellingPair(pair)
                case 1:
                    let pair = coarseResolutionMatching[0]
                    spellPitchesWithSpellingPair(pair)
                default:
                    let pair = getLeastMeanSharpness(coarseResolutionMatching)
                    spellPitchesWithSpellingPair(pair)
                }
            case 1:
                let pair = coarseMatching[0]
                spellPitchesWithSpellingPair(pair)
            default:
                let pair = getLeastMeanSharpness(coarseMatching)
                spellPitchesWithSpellingPair(pair)
            }
        }
    }
    
    // natural
    private func spelledIsNatural(#spelled: Pitch, unspelled: Pitch) {
        
        let spellings = pitchSpellingsByPitchClass[unspelled.pitchClass]
        let unspelledIndex = getIndexOfUnspelled(unspelled)
        
        // Split by unspelled resolution (0.25: 1/8th-tone, 0.5: 1/4-tone, default: 1/2-tone)
        switch unspelled.resolution {
            
        // 1/8-tone ===========================================================================
        case 0.25:
            
            // Split by amount of coarse matching (1: spell; break, default (0): continue)
            switch coarseMatching.count {
            case 1:
                let spelling = coarseMatching[0][unspelledIndex]
                spellPitch(unspelled, spelling: spelling)
                break
            default:
                let stepPreservedIntersectCoarseResMatch = intersection(
                    array0: stepPreserving,
                    array1: coarseResolutionMatching
                )
                
                // Split by amount step preserving AND coarse res matching
                switch stepPreservedIntersectCoarseResMatch.count {
                case 0:
                    println("stepPreserveCoarseResMatchIntersect == 0; uh oh")
                case 1:
                    let spelling = stepPreservedIntersectCoarseResMatch[0][unspelledIndex]
                    spellPitch(unspelled, spelling: spelling)
                    break
                default:
                    let stepPreservedIntersectCoarseDirMatch = intersection(
                        array0: stepPreserving,
                        array1: coarseDirectionMatching
                    )
                    
                    // Split by amount step preserving AND coarse dir matching
                    switch stepPreservedIntersectCoarseDirMatch.count {
                    case 0:
                        let spelling = getLeastSharpOrFlat(
                            pairs: stepPreserving,
                            unspelledIndex: unspelledIndex
                        )
                        spellPitch(unspelled, spelling: spelling)
                    case 1:
                        let spelling = stepPreservedIntersectCoarseDirMatch[0][unspelledIndex]
                        spellPitch(unspelled, spelling: spelling)
                        break
                    default:
                        break
                        //println("> 1 coarse dir match")
                    }
                }
            }
            
        // 1/4-tone ===========================================================================
        case 0.5:
            let spelling = stepPreserving[0][unspelledIndex]
            spellPitch(unspelled, spelling: spelling)
            
        // 1/2-tone ===========================================================================
        default:
            switch stepPreserving.count {
            case 1:
                let spelling = stepPreserving[0][unspelledIndex]
                spellPitch(unspelled, spelling: spelling)
            default:
                let spelling = getLeastSharpOrFlat(
                    pairs: stepPreserving,
                    unspelledIndex: unspelledIndex
                )
                spellPitch(unspelled, spelling: spelling)
            }
        }
    }
    
    // natural up/down
    private func spelledIsNaturalUpOrDown(#spelled: Pitch, unspelled: Pitch) {

        let spellings = pitchSpellingsByPitchClass[unspelled.pitchClass]
        let unspelledIndex = getIndexOfUnspelled(unspelled)
        
        switch unspelled.resolution {
            
        // 1/8-tone ===========================================================================
        case 0.25:
            let fineMatchWithSpelled = getPairsWithSpelling(
                pairs: fineMatching,
                spelling: spelled.spelling!
            )
            switch fineMatchWithSpelled.count {
            case 0:
                break
                //println("none fine matching: uh oh")
            case 1:
                let spelling = fineMatchWithSpelled[0][unspelledIndex]
                spellPitch(unspelled, spelling: spelling)
            default:
                let coarseMatchWithSpelled = getPairsWithSpelling(
                    pairs: coarseMatching,
                    spelling: spelled.spelling!
                )
                let fineMatchIntersectCoarseMatch = intersection(
                    array0: fineMatchWithSpelled,
                    array1: coarseMatchWithSpelled
                )
                switch fineMatchIntersectCoarseMatch.count {
                case 1:
                    let spelling = fineMatchIntersectCoarseMatch[0][unspelledIndex]
                    spellPitch(unspelled, spelling: spelling)
                default:
                    let fineMatchIntersectStepPreserved = intersection(
                        array0: fineMatchWithSpelled,
                        array1: stepPreserving
                    )
                    switch fineMatchIntersectStepPreserved.count {
                    case 0:
                        break
                        //println("none fineMatchIntersectStepPreserved")
                    case 1:
                        let spelling = fineMatchIntersectStepPreserved[0][unspelledIndex]
                        spellPitch(unspelled, spelling: spelling)
                    default:
                        let spelling = fineMatchIntersectStepPreserved[0][unspelledIndex]
                        spellPitch(unspelled, spelling: spelling)
                    }
                }
            }
            
        // 1/4-tone ===========================================================================
        case 0.5:
            let spelling = spellings[0]
            spellPitch(unspelled, spelling: spelling)
            
        // 1/2-tone ===========================================================================
        default:
            switch stepPreserving.count {
            case 1:
                let spelling = stepPreserving[0][unspelledIndex]
                spellPitch(unspelled, spelling: spelling)
            default:
                let spelling = getLeastSharpOrFlat(
                    pairs: stepPreserving,
                    unspelledIndex: unspelledIndex
                )
                spellPitch(unspelled, spelling: spelling)
            }
        }
    }
    
    // sharp / flat / qtr sharp / qtr flat
    private func spelledIsAltered(#spelled: Pitch, unspelled: Pitch) {
        
        let spellings = pitchSpellingsByPitchClass[unspelled.pitchClass]
        let unspelledIndex = getIndexOfUnspelled(unspelled)
        
        switch unspelled.resolution {
        case 0.25:
            let coarseMatchWithSpelled = getPairsWithSpelling(
                pairs: coarseMatching,
                spelling: spelled.spelling!
            )
            switch coarseMatchWithSpelled.count {
            case 1:
                let spelling = coarseMatchWithSpelled[0][unspelledIndex]
                spellPitch(unspelled, spelling: spelling)
            default:
                let coarseResMatchWithSpelled = getPairsWithSpelling(
                    pairs: coarseResolutionMatching,
                    spelling: spelled.spelling!
                )
                switch coarseResMatchWithSpelled.count {
                case 1:
                    let spelling = coarseResMatchWithSpelled[0][unspelledIndex]
                    spellPitch(unspelled, spelling: spelling)
                default:
                    break
                    //println("0 or >1 coarseResMatchWithSpelled")
                }
            }

        case 0.5:
            let spelling = spellings[0]
            spellPitch(unspelled, spelling: spelling)
        default:
            switch coarseMatching.count {
            case 1:
                let spelling = stepPreserving[0][unspelledIndex]
                spellPitch(unspelled, spelling: spelling)
            default:
                let spelling = getLeastSharpOrFlat(
                    pairs: stepPreserving,
                    unspelledIndex: unspelledIndex
                )
                spellPitch(unspelled, spelling: spelling)
            }
        }
    }
    
    // sharp up/down / flat up/down / qtr sharp up/down / qtr flat up/down
    private func spelledIsAlteredUpOrDown(#spelled: Pitch, unspelled: Pitch) {
        
        let spellings = pitchSpellingsByPitchClass[unspelled.pitchClass]
        let unspelledIndex = getIndexOfUnspelled(unspelled)
        
        switch unspelled.resolution {
        case 0.25:
            let fineMatchWithSpelled = getPairsWithSpelling(
                pairs: fineMatching,
                spelling: spelled.spelling!
            )
            switch fineMatchWithSpelled.count {
            case 1:
                let spelling = fineMatchWithSpelled[0][unspelledIndex]
                spellPitch(unspelled, spelling: spelling)
            default:
                let coarseResMatchWithSpelled = getPairsWithSpelling(
                    pairs: coarseResolutionMatching,
                    spelling: spelled.spelling!
                )
                let fineMatchIntersectCoarseResMatch = intersection(
                    array0: fineMatchWithSpelled,
                    array1: coarseResMatchWithSpelled
                )
                switch fineMatchIntersectCoarseResMatch.count {
                case 1:
                    let spelling = fineMatchIntersectCoarseResMatch[0][unspelledIndex]
                    spellPitch(unspelled, spelling: spelling)
                default:
                    let coarseDirMatchWithSpelled = getPairsWithSpelling(
                        pairs: coarseDirectionMatching,
                        spelling: spelled.spelling!
                    )
                    
                    let fineMatchIntersectCoarseDirMatch = intersection(
                        array0: fineMatchWithSpelled,
                        array1: coarseDirMatchWithSpelled
                    )
                    switch fineMatchIntersectCoarseDirMatch.count {
                    case 1:
                        let spelling = fineMatchIntersectCoarseDirMatch[0][unspelledIndex]
                        spellPitch(unspelled, spelling: spelling)
                    default:
                        break
                        //println("0 or >1 fineMatchIntersectCoarseDirMatch")
                    }
                }
            }
            
        case 0.5:
            // coarse direction!
            let spelling = spellings[0]
            spellPitch(unspelled, spelling: spelling)
        
        default:
            let coarseMatchWithSpelled = getPairsWithSpelling(
                pairs: coarseMatching,
                spelling: spelled.spelling!
            )
            
            switch coarseMatchWithSpelled.count {
            case 1:
                let spelling = coarseMatchWithSpelled[0][unspelledIndex]
                spellPitch(unspelled, spelling: spelling)
            default:
                break
                //println("0 or >1 coarseMatchWithSpelled")
            }
        }
    }
    
    private func buildPreferenceArrays() {
        buildStepPreserving()
        buildFineMatching()
        buildCoarseMatching()
        buildCoarseResolutionMatching()
        buildCoarseDirectionMatching()
    }
    
    private func spellPitchesWithSpellingPair(pair: [PitchSpelling]) {
        spellPitch(pitch0, spelling: pair[0])
        spellPitch(pitch1, spelling: pair[1])
    }
    
    private func buildStepPreserving() {
        for s0 in pitchSpellingsByPitchClass[pitch0.pitchClass] {
            for s1 in pitchSpellingsByPitchClass[pitch1.pitchClass] {
                let steps: Float = getSteps(pitch0, s0: s0, p1: pitch1, s1: s1)
                if stepsArePreserved(steps) { stepPreserving.append([s0, s1]) }
            }
        }
    }
    
    private func buildFineMatching() {
        for s0 in pitchSpellingsByPitchClass[pitch0.pitchClass] {
            for s1 in pitchSpellingsByPitchClass[pitch1.pitchClass] {
                if s0.fine == s1.fine { fineMatching.append([s0, s1]) }
            }
        }
    }
    
    private func buildCoarseMatching() {
        for s0 in pitchSpellingsByPitchClass[pitch0.pitchClass] {
            for s1 in pitchSpellingsByPitchClass[pitch1.pitchClass] {
                if s0.coarse == s1.coarse { coarseMatching.append([s0, s1]) }
            }
        }
    }
    
    private func buildCoarseDirectionMatching() {
        for s0 in pitchSpellingsByPitchClass[pitch0.pitchClass] {
            for s1 in pitchSpellingsByPitchClass[pitch1.pitchClass] {
                if s0.coarseDirection == s1.coarseDirection {
                    coarseDirectionMatching.append([s0, s1])
                }
            }
        }
    }
    
    private func buildCoarseResolutionMatching() {
        for s0 in pitchSpellingsByPitchClass[pitch0.pitchClass] {
            for s1 in pitchSpellingsByPitchClass[pitch1.pitchClass] {
                if s0.coarseResolution == s1.coarseResolution {
                    coarseResolutionMatching.append([s0, s1])
                }
            }
        }
    }
    
    private func intersection(#array0: [[PitchSpelling]], array1: [[PitchSpelling]])
        -> [[PitchSpelling]] {
            var intersect: [[PitchSpelling]] = []
            for pair0 in array0 {
                for pair1 in array1 {
                    if pair0[0] === pair1[0] && pair0[1] === pair1[1] {
                        intersect.append(pair0)
                    }
                }
            }
            return intersect
    }
    
    private func spellPitch(pitch: Pitch, spelling: PitchSpelling) {
        pitch.spelling = spelling
    }
    
    private func setPitchSpellingsIfPitchesCanBeSpelledObjectively() {
        for pitch in [pitch0, pitch1] {
            if pitchSpellingsByPitchClass[pitch.pitchClass].count == 1 {
                pitch.spelling = pitchSpellingsByPitchClass[pitch.pitchClass][0]
            }
        }
    }
    
    private func getPairsWithSpelling(#pairs: [[PitchSpelling]], spelling: PitchSpelling)
        -> [[PitchSpelling]] {
        var pairsWithSpelling: [[PitchSpelling]] = []
        for pair in pairs {
            for _spelling in pair {
                if _spelling.coarse == spelling.coarse && _spelling.fine == spelling.fine {
                    pairsWithSpelling.append(pair)
                    break
                }
            }
        }
        return pairsWithSpelling
    }
    
    private func getLeastSharpOrFlat(#pairs: [[PitchSpelling]], unspelledIndex: Int)
        -> PitchSpelling {
        var leastSharpOrFlat: PitchSpelling?
        for pair in pairs {
            let unspelledSpelling = pair[unspelledIndex]
            if leastSharpOrFlat == nil { leastSharpOrFlat = unspelledSpelling }
            else if abs(unspelledSpelling.sharpness) < leastSharpOrFlat!.sharpness {
                leastSharpOrFlat = unspelledSpelling
            }
        }
        return leastSharpOrFlat!
    }
    
    
    private func getLeastMeanSharpness(pairs: [[PitchSpelling]]) -> [PitchSpelling] {
        var least: [PitchSpelling]?
        for pair in pairs {
            if least == nil { least = pair }
            else if getMeanSharpness(pair: pair) < getMeanSharpness(pair: least!) {
                least = pair
            }
        }
        return least!
    }
    
    private func getMeanSharpness(#pair: [PitchSpelling]) -> Float {
        return abs(Float(pair[0].sharpness + pair[1].sharpness)) / 2.0
    }
    
    private func setSpelledAndUnspelled() -> (Pitch, Pitch) {
        var spelled: Pitch?
        var unspelled: Pitch?
        if pitch0.hasBeenSpelled { spelled = pitch0; unspelled = pitch1 }
        else { spelled = pitch1; unspelled = pitch0 }
        return (spelled!, unspelled!)
    }
    
    private func stepsArePreserved(steps: Float) -> Bool {
        let intervalRangeByStep: Dictionary<Float, [Float]> = [
            0.0: [0.00, 00.00],
            0.5: [0.25, 02.25],
            1.0: [2.50, 04.50],
            1.5: [4.50, 06.50],
            2.0: [6.00, 07.50],
            2.5: [7.50, 09.50],
            3.0: [9.50, 11.75],
            3.5: [0.00, 00.00]
        ]
        if (
            interval >= intervalRangeByStep[steps]![0] &&
            interval <= intervalRangeByStep[steps]![1]
        ) { return true }
        return false
    }
    
    private func getIndexOfUnspelled(unspelled: Pitch) -> Int {
        return unspelled === pitch0 ? 0 : 1
    }
    
    private func getSteps(p0: Pitch, s0: PitchSpelling, p1: Pitch, s1: PitchSpelling) -> Float {
        var staffSpaces: [Float] = [
            Float(s0.staffSpacesFromMiddleC) + 3.5 * Float(p0.octave),
            Float(s1.staffSpacesFromMiddleC) + 3.5 * Float(p1.octave)
        ]
        staffSpaces.sort { $0 < $1 }
        var steps: Float = staffSpaces[1] - staffSpaces[0]
        while steps > 3.5 { steps -= 3.5 }
        return steps
    }
    
    private func getIntervalComplexityByIntervalPitchClass() -> Int {
        let intervalComplexityByIntervalPitchClass: [Float] = [
            0, 1, 11, 7, 5, 4, 3, 2, 10, 9,
            0.25, 11.75, 7.25, 6.75, 5.25, 4.75, 4.25, 3.75, 3.25, 2.75, 1.25, 0.75,
            11.25, 10.75, 2.25, 1.75, 10.25, 9.75, 9.25, 8.75,
            6, 8,
            6.25, 5.75, 8.25, 7.75,
            0.5, 11.5, 7.5, 6.5, 5.5, 4.5, 3.5, 1.5, 10.5, 2.5, 9.5, 8.5
        ]
        for (i, interval) in enumerate(intervalComplexityByIntervalPitchClass) {
            if interval == self.interval { return i }
        }
        return 100
    }
}