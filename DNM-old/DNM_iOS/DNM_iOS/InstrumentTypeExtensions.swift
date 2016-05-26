//
//  InstrumentTypeExtensions.swift
//  DNM
//
//  Created by James Bean on 1/14/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation
import DNMModel

extension InstrumentType {
    
    public var clefContexts: [ClefContext] { return getClefContexts() }
    
    private func getClefContexts() -> [ClefContext] {
        let data = PreferredClefsAndTranspositionByInstrumentType.sharedInstance[self.rawValue]
        return data.map { clefContextFor($0.1) }
    }
    
    private func clefContextFor(jsonObject: JSON) -> ClefContext {
        let type = clefTypeFor(jsonObject)
        let transposition = transpositionFor(jsonObject)
        let displayPreference = transposition ==  0 ? false : displayPreferenceFor(jsonObject)
        
        return ClefContext(
            type: type,
            transposition: transposition,
            showsTransposition: displayPreference
        )
    }
    
    private func clefTypeFor(jsonObject: JSON) -> ClefStaffType {
        if let typeString = jsonObject["clef"].string {
            if let clefType = ClefStaffType(rawValue: typeString) { return clefType }
        }
        return .Treble
    }
    
    private func transpositionFor(jsonObject: JSON) -> Int {
        return jsonObject["transposition"].int ?? 0
    }
    
    private func displayPreferenceFor(jsonObject: JSON) -> Bool {
        return jsonObject["transposition_shown"].bool ?? false
    }
    
    private class PreferredClefsAndTranspositionByInstrumentType {
        class var sharedInstance : JSON {
            struct Static {
                static let instance: JSON = Static.getInstance()
                static func getInstance() -> JSON {
                    let bundle = NSBundle(forClass: StaffEvent.self)
                    let filePath = bundle.pathForResource(
                        "PreferredClefsAndTranspositionByInstrumentType", ofType: "json"
                    )!
                    let jsonData = NSData(contentsOfFile: filePath)!
                    let jsonObj: JSON = JSON(data: jsonData)
                    return jsonObj
                }
            }
            return Static.instance
        }
    }
}