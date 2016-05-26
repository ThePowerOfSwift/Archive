//
//  Tokenizer.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class Tokenizer {
    
    // Commands that have global scope
    internal enum GlobalCommand: String {
        case LineComment = "//"
        case PerformerDeclaration = "P:"
        case Measure = "#"
        case DurationNodeStackModeMeasure = "|"
        case DurationNodeStackModeIncrement = "+"
        case RehearsalMarking = "-R"
        case TempoMarking = "-T"
    }
    
    // Commands that are interpreted into Components for DurationNodeLeaves
    internal enum LeafCommand: String {
        case Label = "-l"
        case Node = "•"
        case Edge = "~"
        case EdgeStop = "ø"
        case Pitch = "-p"
        case Articulation = "-a"
        case DynamicMarking = "-d"
        case SlurStart = "("
        case SlurStop = ")"
        case ExtensionStop = "<-"
    }
    
    internal enum Error: ErrorType {
        case InvalidResult
        case InvalidIntArgument
        case InvalidFloatArgument
        case InvalidArgument(String)
        case InvalidPerformerID(String)
        case InvalidInstrumentID(String)
        case InvalidInstrumentType(String)
        case InvalidArticulationMarking(String)
        case InvalidPitchArgument(String)
        case InvalidDynamicMarkingArgument(String)
        case InvalidDurationArgument(String)
        case InvalidDurationNodeRootArgument(String)
        case NoArgumentsFound(String)
        case InvalidCommand(String)
        case NewLine
    }
    
    private struct ScannerState {
        let charactersToBeSkipped: NSCharacterSet?
        init(charactersToBeSkipped: NSCharacterSet? = nil) {
            self.charactersToBeSkipped = charactersToBeSkipped
        }
    }

    internal var identifier: String { return "Root" }
    internal var startLocation: Int
    internal let scanner: NSScanner
    private var scannerState: ScannerState = ScannerState()
    
    internal init(string: String) {
        self.scanner = NSScanner(string: string)
        self.startLocation = scanner.scanLocation
    }
    
    internal init(scanner: NSScanner) {
        self.scanner = scanner
        self.startLocation = scanner.scanLocation
    }
    
    final internal func makeToken() throws -> Token {
        saveScannerState()
        configureScanner()
        defer { restoreScannerState() }
        do { return try result() }
        catch {
            unwindScanner()
            throw error
        }
    }
    
    internal func result() throws -> Token {
        let tokenContainer = TokenContainer(identifier: "Root")
        while !scanner.atEnd {
            do { try addLineTokenTo(tokenContainer) }
            catch { incrementScanner() }
        }
        return tokenContainer
    }

    private func saveScannerState() {
        scannerState = ScannerState(charactersToBeSkipped: scanner.charactersToBeSkipped)
    }
    
    internal func configureScanner() {
        scanner.charactersToBeSkipped = NSCharacterSet(charactersInString: " ")
    }
    
    private func restoreScannerState() {
        scanner.charactersToBeSkipped = scannerState.charactersToBeSkipped
    }
    
    internal func makeTokenContainer() -> TokenContainer {
        return TokenContainer(
            identifier: identifier,
            openingValue: "",
            startIndex: startLocation
        )
    }
    
    internal func incrementScanner() {
        if !scanner.atEnd { scanner.scanLocation++ }
    }
    
    private func addLineTokenTo(tokenContainer: TokenContainer) throws {
        let lineTokenizer = LineTokenizer(scanner: scanner)
        let lineToken = try lineTokenizer.makeToken()
        tokenContainer.addToken(lineToken)
    }
    
    private func unwindScanner() {
        scanner.scanLocation = startLocation
    }
    
    internal func scanString(string: String) -> Bool {
        var str: NSString?
        return scanner.scanString(string, intoString: &str)
    }
    
    internal func addTokenForIntWith(identifier: String,
        toTokenContainer tokenContainer: TokenContainer
    ) throws
    {
        let token = try makeTokenForIntWith(identifier)
        tokenContainer.addToken(token)
    }
    
    internal func makeTokenForIntWith(identifier: String) throws -> TokenInt {
        let startLoc = scanner.scanLocation
        var intValue: Int32 = 0
        if scanner.scanInt(&intValue) {
            return TokenInt(
                identifier: identifier,
                value: Int(intValue),
                startIndex: startLoc,
                stopIndex: scanner.scanLocation - 1
            )
        } else {
            throw Error.InvalidArgument("Not an Int value")
        }
    }
    
    internal func addTokenForFloatWith(identifier: String,
        toTokenContainer tokenContainer: TokenContainer
    ) throws
    {
        let token = try makeTokenForFloatWith(identifier)
        tokenContainer.addToken(token)
    }
    
    internal func makeTokenForFloatWith(identifier: String) throws -> TokenFloat {
        let startLoc = scanner.scanLocation
        var floatValue: Float = 0
        if scanner.scanFloat(&floatValue) {
            return TokenFloat(
                identifier: identifier,
                value: floatValue,
                startIndex: startLoc,
                stopIndex: scanner.scanLocation - 1
            )
        } else {
            throw Error.InvalidArgument("Not a Float value")
        }
    }
    
    internal func addTokenFor(string: String,
        withIdentifier identifier: String, toTokenContainer tokenContainer: TokenContainer
    ) throws
    {
        let token = try makeTokenFor(string,
            withIdentifier: identifier,
            toTokenContainer: tokenContainer
        )
        tokenContainer.addToken(token)
    }
    
    internal func makeTokenFor(string: String,
        withIdentifier identifier: String,
        toTokenContainer tokenContainer: TokenContainer
    ) throws -> TokenString
    {
        let startLoc = scanner.scanLocation
        if scanString(string) {
            return TokenString(
                identifier: identifier,
                value: string,
                startIndex: startLoc
            )
        } else {
            throw Error.InvalidArgument("Not a String value")
        }
    }
    
    internal func newLine() -> Bool {
        var str: NSString?
        let beforeLoc = scanner.scanLocation
        let newLineFound = scanner.scanCharactersFromSet(.newlineCharacterSet(),
            intoString: &str
        )
        scanner.scanLocation = beforeLoc
        return newLineFound
    }
    
    // throws?
    internal func addTokenTo(tokenContainer: TokenContainer) throws {
        // override in subclasses
    }
    
    internal func reachedEndOfTask() -> Bool {
        return newLine() || foundNextCommand()
    }
    
    internal func foundNextCommand() -> Bool {
        let unwindLocation = scanner.scanLocation
        if commandMatch() != nil {
            scanner.scanLocation = unwindLocation
            return true
        }
        return false
    }
    
    internal func commandMatch() -> GlobalCommand? {
        var str: NSString?
        for command in iterateEnum(GlobalCommand) {
            if scanner.scanString(command.rawValue, intoString: &str) { return command }
        }
        return nil
    }
}