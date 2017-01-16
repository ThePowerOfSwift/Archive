//
//  Directory.swift
//  ScriptingTools
//
//  Created by James Bean on 4/14/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import SwiftShell

/// Current working directory.
public var currentDirectory: Path { return run("pwd") }

/// Files (including subdirectories) within the current working directory.
public var files: [Path] { return run("ls").characters.split { $0 == "\n" }.map { Path($0) } }

/// Directories within the current working directory.
public var directories: [Path] { return files.filter { $0.isDirectory } }

/**
 - parameter path: Change the current working directory to the given `Path`.
 */
public func changeDirectory(to path: Path) {
    main.currentdirectory = path
}

/**
 Change `currentDirectory` to its parent directory.
 */
public func changeDirectoryToParent() {
    changeDirectory(to: "..")
}

/**
 Make a directory at the given `Path`.
 */
public func makeDirectory(at path: Path) {
    run("mkdir", path)
}
