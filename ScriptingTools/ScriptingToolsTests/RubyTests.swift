//
//  RubyTests.swift
//  ScriptingTools
//
//  Created by James Bean on 4/17/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import ScriptingTools

class RubyTests: XCTestCase {

    func testRubyScript() {
        let script = ruby(
            fileAt: "../generate_project.rb",
            function: "integrate_ios_frameworks",
            parameters: "TestFramework", "something something something"
        )

        print("script: \(script)")
    }
}
