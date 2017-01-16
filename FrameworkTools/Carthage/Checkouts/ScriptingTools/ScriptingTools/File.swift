//
//  File.swift
//  ScriptingTools
//
//  Created by James Bean on 4/15/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import SwiftShell

/**
 Create a file at the given `Path` if it does not yet exist.
 */
public func touch(newFileAt path: Path) {
    run("touch", path)
}

/**
 - parameter path:      `Path` of file to be removed.
 - parameter recursive: If to forceably and recursively remove a directory.
 */
public func remove(fileAt path: Path, recursively recursive: Bool = false) {
    recursive ? run("rm", "-rf", path) : run("rm", path)
}

/**
 Copy the file at a given `Path` to a given destination `Path`.
 
 - TODO: recursive option
 */
public func copy(fileAt path: Path, to destination: Path) {
    run("cp", path, destination)
}

/**
 Change the mode of the file at a given `Path` to the given mode.
 */
public func changeMode(mode: String, forFileAt path: Path) {
    run("chmod", mode, path)
}

/**
 Write the given `line` at the end of the file at the given `path`.
 */
public func append(line line: String, toFileAt path: Path) {
    run(bash: "echo \"\(line)\" >> \(path)")
}
