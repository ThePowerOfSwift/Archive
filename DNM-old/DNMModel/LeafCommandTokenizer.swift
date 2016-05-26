//
//  LeafCommandTokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/24/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class LeafCommandTokenizer: CommandTokenizer {
    
    internal class func tokenizerFor(command: LeafCommand, scanner: NSScanner)
        -> CommandTokenizer
    {
        var classType: CommandTokenizer.Type {
            switch command {
            case .Label:
                return LabelCommandTokenizer.self
            case .Node:
                return NodeCommandTokenizer.self
            case .Edge:
                return EdgeCommandTokenizer.self
            case .EdgeStop:
                return EdgeStopCommandTokenizer.self
            case .Pitch:
                return PitchCommandTokenizer.self
            case .Articulation:
                return ArticulationMarkingCommandTokenizer.self
            case .DynamicMarking:
                return DynamicMarkingCommandTokenizer.self
            case .SlurStart:
                return SlurStartCommandTokenizer.self
            case .SlurStop:
                return SlurStopCommandTokenizer.self
            case .ExtensionStop:
                return ExtensionStopCommandTokenizer.self
            }
        }
        return classType.init(scanner: scanner, openingValue: command.rawValue)
    }
    
    internal override func reachedEndOfTask() -> Bool {
        return newLine() || foundNextCommand()
    }
    
    internal override func foundNextCommand() -> Bool {
        let unwindLocation = scanner.scanLocation
        if commandMatch() != nil || leafCommandMatch() != nil {
            scanner.scanLocation = unwindLocation
            return true
        }
        return false
    }

    internal func leafCommandMatch() -> LeafCommand? {
        var str: NSString?
        for command in iterateEnum(LeafCommand) {
            if scanner.scanString(command.rawValue, intoString: &str) { return command }
        }
        return nil
    }
}