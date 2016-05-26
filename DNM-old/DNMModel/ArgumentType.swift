//
//  ArgumentType.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation


/**
Type of input that the DNMTokenizer may scan for a given context

- String:         String value
- Int:            Integer value
- Float:          Float value
- PitchString:    String representation of Pitch (e.g., c#4, d_qf_up_7, etc)
- Duration:       Pair of Integer values (separated by single space)
- DynamicMarking: Any combination of "opmf" (e.g., mf, fff, ppp, offfpp, etc)
- Articulation:   Single instance of [., >, -]
- Spanner:        Generic type that manages interpolations between values (e.g, hairpin)
*/
public enum ArgumentType: String {
    case String
    case Int
    case Float
    case Duration
    case PitchString
    case DynamicMarking
    case Articulation
    case Spanner
}