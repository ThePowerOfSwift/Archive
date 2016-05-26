//
//  PitchParser.swift
//  DNMModel
//
//  Created by James Bean on 1/20/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public class PitchParser: Parser {
    
    internal override func makeScannerWith(string: String) -> NSScanner {
        let scanner = NSScanner(string: string)
        scanner.charactersToBeSkipped = NSCharacterSet(charactersInString: "_")
        return scanner
    }
    
    internal override func resultWith(scanner: NSScanner) -> Any? {
        guard let letterName = letterNameCharacterScannedWith(scanner) else {
            didFail = true
            return nil
        }
        
        let quarterToneMultiplier = quarterToneMultiplierCharacterScannedWith(scanner)
        let halfTone = halfToneCharacterScannedWith(scanner)
        let eighthTone = eighthToneCharacterScannedWith(scanner)
        let octave = octaveCharacterScannerWith(scanner)
        
        guard !charactersRemainUnscannedBy(scanner) else {
            didFail = true
            return nil
        }
        
        return midiFloatValueWith(letterName,
            octave,
            halfTone,
            quarterToneMultiplier,
            eighthTone
        )
    }
    
    private func letterNameCharacterScannedWith(scanner: NSScanner) -> PitchLetterName? {
        guard let firstCharacter: String = scanner.string[scanner.scanLocation] else {
            return nil
        }

        if let letterName = PitchLetterName.pitchLetterNameWithString(string: firstCharacter) {
            if !scanner.atEnd { scanner.scanLocation++ }
            return letterName
        }
        return nil
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