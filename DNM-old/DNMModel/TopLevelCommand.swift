//
//  TopLevelCommand.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

/**
Command that switches the DNMTokenizer to scan for tailored information types
*/
public struct TopLevelCommand {
    
    public var identifier: String
    public var openingValue: String
    public var allowableTypes: [ArgumentType]
    
    /**
     Create a TopLevelCommand with identifier, opening value and allowable types.
     
     - parameter identifier:     String that is used by syntax highlighter to highlighter
     - parameter openingValue:   String that switches DNMTokenizer onto tailored path
     - parameter allowableTypes: Types that the DNMTokenizer can scan for
     
     - returns: TopLevelCommand
     */
    public init(identifier: String, openingValue: String, allowableTypes: [ArgumentType]) {
        self.identifier = identifier
        self.openingValue = openingValue
        self.allowableTypes = allowableTypes
    }
}
