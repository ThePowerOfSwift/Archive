//
//  Path.swift
//  ScriptingTools
//
//  Created by James Bean on 4/15/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import SwiftShell

/// Path.
public typealias Path = String

extension Path {
    
    /// `true` if file at `Path` is a directory. Otherwise, `false`.
    public var isDirectory: Bool {
        return run(bash: "if [ -d '\(self)' ]; then echo '1'; fi") == "1"
    }
    
    /// `true` if file at `Path` exists. Otherwise, `false`.
    public var exists: Bool {
        return run(bash: "if [ -e '\(self)' ]; then echo '1'; fi") == "1"
    }
}
