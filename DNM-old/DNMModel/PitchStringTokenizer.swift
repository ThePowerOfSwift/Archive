//
//  PitchStringTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class PitchStringTokenizer: Tokenizer {
    
    internal override func configureScanner() {
        scanner.charactersToBeSkipped = NSCharacterSet(charactersInString: "_")
    }
    
    internal override func result() throws -> Token {
        do {
            let letterName = try letterNameCharacterScannedWith(scanner)
            let quarterToneMultiplier = quarterToneMultiplierCharacterScannedWith(scanner)
            let halfTone = halfToneCharacterScannedWith(scanner)
            let eighthTone = eighthToneCharacterScannedWith(scanner)
            let octave = octaveCharacterScannerWith(scanner)
            
            let midiFloatValue = midiFloatValueWith(letterName,
                octave,
                halfTone,
                quarterToneMultiplier,
                eighthTone
            )
            
            return TokenFloat(
                identifier: "Value",
                value: midiFloatValue,
                startIndex: startLocation,
                stopIndex: scanner.scanLocation - 1
            )
        }
    }
    
    private func letterNameCharacterScannedWith(scanner: NSScanner) throws -> PitchLetterName {
        guard let firstCharacter: String = scanner.string[scanner.scanLocation] else {
            throw Error.InvalidResult
        }
        if let letterName = PitchLetterName.pitchLetterNameWithString(string: firstCharacter) {
            if !scanner.atEnd { scanner.scanLocation++ }
            return letterName
        }
        throw Error.InvalidResult
    }
    
    // TODO: add "flat" and "sharp" as legal
    private func halfToneCharacterScannedWith(scanner: NSScanner) -> Float {
        var str: NSString?
        let flatSet = NSCharacterSet(charactersInString: "b")
        let sharpSet = NSCharacterSet(charactersInString: "#s")
        if scanner.scanCharactersFromSet(flatSet, intoString: &str) { return -1 }
        if scanner.scanCharactersFromSet(sharpSet, intoString: &str) { return 1 }
        return 0
    }
    
    private func quarterToneMultiplierCharacterScannedWith(scanner: NSScanner) -> Float {
        var str: NSString?
        let quarterToneSet = NSCharacterSet(charactersInString: "q")
        if scanner.scanCharactersFromSet(quarterToneSet, intoString: &str) { return 0.5 }
        return 1
    }
    
    private func eighthToneCharacterScannedWith(scanner: NSScanner) -> Float {
        var str: NSString?
        if scanner.scanString("up", intoString: &str) { return 0.25 }
        if scanner.scanString("down", intoString: &str) { return -0.25 }
        return 0
    }
    
    private func octaveCharacterScannerWith(scanner: NSScanner) -> Float {
        var floatValue: Float = 4.0
        scanner.scanFloat(&floatValue)
        return floatValue
    }
    
    private func charactersRemainUnscannedBy(scanner: NSScanner) -> Bool {
        return !scanner.atEnd
    }
    
    private func midiFloatValueWith(letterName: PitchLetterName,
        _ octaveValue: Float,
        _ halfToneValue: Float,
        _ quarterToneMultiplier: Float,
        _ eighthToneValue: Float
    ) -> Float
    {
        return (
            (octaveValue + 1) * 12
            + letterName.distanceFromC
            + halfToneValue * quarterToneMultiplier
            + eighthToneValue
        )
    }
}