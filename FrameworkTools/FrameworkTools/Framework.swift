//
//  Framework.swift
//  FrameworkTools
//
//  Created by James Bean on 4/19/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation
import SwiftShell
import ScriptingTools

public final class Framework {

    // AKA $(PROJECT_DIR)
    private var projectDirectory: Path!
    
    // Name of the Framework
    private let name: String
    
    // Create a Framework from scratch
    public init(
        name: String,
        git shouldPrepareGit: Bool = true,
        carthage shouldPrepareCarthage: Bool = true,
        travis shouldPrepareTravis: Bool = true
    )
    {
        self.name = name
        createFileStructure()
        if shouldPrepareGit { prepareGit() }
        if shouldPrepareCarthage { prepareCarthage() }
        if shouldPrepareTravis { prepareTravis() }
        configureProject()
    }
    
    /*
    // Create a Framework from an extant file
    public init(projectDirectory: Path) throws {
        changeDirectory(to: projectDirectory)
        
    }
    */
    
    private func prepareGit() {
        changeDirectory(to: projectDirectory)
        run("git", "init")
    }
    
    private func prepareCarthage() {
        changeDirectory(to: projectDirectory)
        touch(newFileAt: "Cartfile")
    }
    
    private func prepareTravis() {
        let travisPath = ".travis.yml"
        changeDirectory(to: projectDirectory)
        touch(newFileAt: travisPath)
        append(line: "language: objective-c", toFileAt: travisPath)
        append(line: "osx_image: xcode7.3", toFileAt: travisPath)
        append(line: "xcode_project: \(name).xcodeproj", toFileAt: travisPath)
        append(line: "xcode_scheme: \(name)Mac", toFileAt: travisPath)
        append(line: "xcode_sdk: macosx", toFileAt: travisPath)
        append(line: "before_script:", toFileAt: travisPath)
        append(line: "  - carthage bootstrap", toFileAt: travisPath)
    }
    
    private func configureProject() {
        print("Configuring project for \(name)")
        createProject()
        createInfoPropertyLists()
        configurePBXGroups()
        configureTargets()
        configureHeader()
        configureSchemes()
        configureBuildConfigurationSettings()
        addCopyBuildPhaseForTestTargets()
    }
    
    private func createFileStructure() {
        print("Creating file structure for \(name) at: \(currentDirectory)")
        makeDirectory(at: name)
        changeDirectory(to: name)
        projectDirectory = currentDirectory
        createDirectoriesForTargets()
    }
    
    private func createDirectoriesForTargets() {
        [name, "\(name)Tests"].forEach { makeDirectory(at: $0) }
    }
    
    private func createProject() {
        run(rubyFileAt: newFrameworkPath, function: "create_project", parameters: name)
    }
    
    private func createInfoPropertyLists() {
        // TODO: ensure info plists exist
        copy(fileAt: primaryTargetInfoPropertyList, to: "\(name)/Info.plist")
        copy(fileAt: testsTargetInfoPropertyList, to: "\(name)Tests/Info.plist")
    }
    
    private func configurePBXGroups() {
        run(rubyFileAt: newFrameworkPath, function: "configure_PBXGroups", parameters: name)
    }
    
    private func configureTargets() {
        run(rubyFileAt: newFrameworkPath, function: "configure_targets", parameters: name)
    }
    
    private func configureHeader() {
        createHeader()
        run(rubyFileAt: newFrameworkPath, function: "configure_header", parameters: name)
    }
    
    private func createHeader() {
        touch(newFileAt: "\(name)/\(name).h")
    }
    
    private func addCopyBuildPhaseForTestTargets() {
        run(rubyFileAt: newFrameworkPath,
            function: "add_copy_files_build_phase_for_test_targets",
            parameters: name
        )
    }
    
    private func configureSchemes() {
        run(rubyFileAt: newFrameworkPath, function: "configure_schemes", parameters: name)
    }
    
    private func configureBuildConfigurationSettings() {
        run(rubyFileAt: newFrameworkPath,
            function: "configure_build_configuration_settings",
            parameters: name
        )
    }
}