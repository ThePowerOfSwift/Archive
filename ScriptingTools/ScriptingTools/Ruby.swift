//
//  Ruby.swift
//  ScriptingTools
//
//  Created by James Bean on 4/15/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import SwiftShell

// TODO: add run(rubyFileAt class method parameters)

public func run(rubyFileAt path: Path, function: String = "", parameters: String...) {
    run(bash: ruby(fileAt: path, function: function, parameters: parameters))
}

public func run(rubyFileAt path: Path, function: String = "", parameters: [String]) {
    run(bash: ruby(fileAt: path, function: function, parameters: parameters))
}

public func run(ruby code: String) {
    run(bash: "ruby -e \"\(code)\"")
}

public func ruby(fileAt path: Path, function: String = "", parameters: String...) -> String {
    return ruby(fileAt: path, function: function, parameters: parameters)
}

public func ruby(fileAt path: Path, function: String = "", parameters: [String]) -> String {
    var code = "ruby "
    code += "-r "
    code += "\"\(path)\" "
    code += "-e "
    code += "\"\(function)"
    if parameters.count > 0 {
        code += "("
        for (p, param) in parameters.enumerate() {
            code += "'\(param)'"
            if p < parameters.count - 1 { code += ", " }
        }
        code += ")"
    }
    code += "\""
    return code
}
