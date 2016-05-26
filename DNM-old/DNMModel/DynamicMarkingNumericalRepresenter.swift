//
//  DynamicMarkingNumericalRepresenter.swift
//  DNMModel
//
//  Created by James Bean on 12/28/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

public class DynamicMarkingNumericalRepresenter {
    
    private let string: String
    
    private var numericalRepresentation: [Int] = []
    private var pCount: Int = 0
    private var fCount: Int = 0
    
    public init(string: String) {
        self.string = string
    }
    
    public func getNumericalRepresentation() throws -> [Int] {
        var index = 0
        while index < string.characters.count {
            if let character = stringValueAt(index) {
                manageCharacter(character, index: &index)
            }
        }
        bothDump()
        return numericalRepresentation
    }
    
    private func manageCharacter(character: String, inout index: Int) {
        switch character {
        case "m": manage_m(index: &index)
        case "o": manage_o(index: &index)
        case "p": manage_p(index: &index)
        case "f": manage_f(index: &index)
        default: index++
        }
    }
    
    private func manage_f(inout index index: Int) {
        pDump()
        fCount++
        index++
    }
    
    private func manage_p(inout index index: Int) {
        fDump()
        pCount++
        index++
    }
    
    private func manage_o(inout index index: Int) {
        bothDump()
        numericalRepresentation.append(Int.min)
        index++
    }
    
    private func manage_m(inout index index: Int) {
        if index < string.characters.count - 1 {
            if let nextCharacter = stringValueAt(index + 1) {
                switch nextCharacter {
                case "f":
                    numericalRepresentation.append(1)
                    index += 2
                case "p":
                    numericalRepresentation.append(-1)
                    index += 2
                default:
                    index += 1
                }
            }
        } else { index++ }
    }
    
    private func bothDump() {
        pDump()
        fDump()
    }
    
    private func pDump() {
        if pCount > 0 {
            numericalRepresentation.append(-(pCount + 1))
            pCount = 0
        }
    }
    
    private func fDump() {
         if fCount > 0 {
            numericalRepresentation.append(+(fCount + 1))
            fCount = 0
        }
    }
    
    private func stringValueAt(index: Int) -> String? {
        if index >= 0 && index < string.characters.count {
            return String(Array(string.characters)[index])
        }
        return nil
    }
    
    /*
    public class func numericalRepresentationFor(string: String)
        -> [DynamicMarkingNumericalRepresentation]?
    {
        func stringValueAt(index: Int) -> String? {
            if index >= 0 && index < string.characters.count {
                return String(Array(string.characters)[index])
            }
            return nil
        }
        
        var values: [Int] = []
        var fCount: Int = 0
        var pCount: Int = 0
        
        func pDump() { if pCount > 0 { values.append(-(pCount + 1)); pCount = 0 } }
        func fDump() { if fCount > 0 { values.append(+(fCount + 1)); fCount = 0 } }
        func bothDump() {
            if pCount > 0 { values.append(-(pCount + 1)); pCount = 0 }
            if fCount > 0 { values.append(+(fCount + 1)); fCount = 0 }
        }
        
        var c = 0
        while c < string.characters.count {
            print("string value at c: \(c): \(stringValueAt(c))")
            if let character = stringValueAt(c) {
                switch character {
                case "m":
                    if c < string.characters.count - 1 {
                        if let nextCharacter = stringValueAt(c + 1) {
                            switch nextCharacter {
                            case "f":
                                values.append(1)
                                c += 2
                            case "p":
                                values.append(-1)
                                c += 2
                            default:
                                c += 1
                            }
                        }
                    } else { c++ }
                case "o":
                    
                    bothDump()
                    values.append(Int.min)
                    c++
                case "p":
                    fDump()
                    pCount++
                    c++
                case "f":
                    pDump()
                    fCount++
                    c++
                default:
                    c++
                }
            }
        }
        bothDump()
        return values
    }   
    */
}