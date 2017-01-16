//
//  Paths.swift
//  FrameworkTools
//
//  Created by James Bean on 4/19/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

private let bundle = NSBundle(forClass: Framework.self)

/// Path for new_framework.rb
public let newFrameworkPath = bundle.pathForResource("new_framework", ofType: "rb")!

/// Path for integrate_frameworks.rb
public let integrateFrameworksPath = bundle.pathForResource("integrate_frameworks", ofType: "rb")!

/// Path for the default Info.plist for a Primary target
public let primaryTargetInfoPropertyList = bundle.pathForResource("Primary", ofType: "plist")!

/// Path for the default Info.plist for a Unit Test Bundle
public let testsTargetInfoPropertyList = bundle.pathForResource("Tests", ofType: "plist")!