//
//  DNMTokenizer.swift
//  Tokenizer3
//
//  Created by James Bean on 11/8/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation


/// Creates Tokens of incoming text, tailored for the DNMShorthand Text Input Language
public class DNMTokenizer {

    // break this out of here
    /**
    Single line of text, with helpful information
    */
    public struct Line: CustomStringConvertible {
        
        public var description: String { return getDescription() }
        
        let string: String
        let startIndex: Int
        let stopIndex: Int
        var indentationLevel: Int { return getIndentationLevel() }
        
        init(string: String, startingAtIndex startIndex: Int) {
            self.string = string
            self.startIndex = startIndex
            self.stopIndex = startIndex + string.characters.count
        }
        
        private func getIndentationLevel() -> Int {
            
            // create scanner to isolate just the initial whitespace characters
            let scanner = NSScanner(string: string)
            scanner.charactersToBeSkipped = nil
            
            // create non-whitespace character set
            let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
            characterSet.formUnionWithCharacterSet(
                NSMutableCharacterSet.punctuationCharacterSet()
            )
            
            // create a string of just the leading whitespace for this line
            var ws: NSString?
            scanner.scanUpToCharactersFromSet(characterSet, intoString: &ws)
            
            if ws != nil {
                // scan through each character in the leading whitespace of this line
                let whiteSpaceScanner = NSScanner(string: ws as! String)
                whiteSpaceScanner.charactersToBeSkipped = nil
                
                // get the amount of spaces and tabs in the leading whitespace of this line
                var spaceCount: Int = 0
                var tabCount: Int = 0
                while !whiteSpaceScanner.atEnd {
                    if whiteSpaceScanner.scanString("\t", intoString: &ws) { tabCount++ }
                    else if whiteSpaceScanner.scanString(" ", intoString: &ws) { spaceCount++ }
                    else { whiteSpaceScanner.scanLocation++ }
                }
                let indentationLevel = Int(floor(Float(spaceCount) / 4)) + tabCount
                return indentationLevel
            }
            return 0
        }
        
        private func getDescription() -> String {
            var description: String = "Line: "
            description += "'\(string)': from \(startIndex) to \(stopIndex)"
            description += " indent: \(indentationLevel)"
            return description
        }
    }
    
    // break this out of here
    /**
    Collection of Line objects, with helpful methods
    */
    public struct LineCollection: CustomStringConvertible {
        
        public var description: String { return getDescription() }
        
        var lines: [Line]
        
        init() {
            self.lines = []
        }
        
        mutating func addLineWithString(string: String, startingAtIndex startIndex: Int) {
            let line = Line(string: string, startingAtIndex: startIndex)
            addLine(line)
        }
        
        mutating func addLine(line: Line) {
            lines.append(line)
            lines.sortInPlace { $0.startIndex < $1.startIndex }
        }
        
        func lineStartingAtIndex(index: Int) -> Line? {
            if lines.count == 0 { return nil }
            for line in lines { if line.startIndex == index { return line } }
            return nil
        }
        
        func lineIncludingIndex(index: Int) -> Line? {
            if lines.count == 0 { return nil }
            for line in lines {
                if line.startIndex <= index && line.stopIndex >= index { return line }
            }
            return nil
        }
        
        private func getDescription() -> String {
            var description: String = ""
            for line in lines { description += "\n\(line)" }
            return description
        }
    }
    
    /// All TopLevelCommands, sourced from the JSON file: TopLevelCommands.json
    public class TopLevelCommands {
        class var sharedInstance: JSON {
            struct Static {
                static let instance: JSON = Static.getInstance()
                static func getInstance() -> JSON {
                    let bundle = NSBundle(forClass: TopLevelCommands.self)
                    let filePath = bundle.pathForResource("TopLevelCommands", ofType: "json")!
                    let jsonData = NSData(contentsOfFile: filePath)!
                    let jsonObj = JSON(data: jsonData)
                    return jsonObj
                }
            }
            return Static.instance
        }
    }
    
    // MARK: - Character Sets
    
    // these will be held locally in each ArgumentTokenizer subclass
    private let whitespaceCharacterSet = NSCharacterSet.whitespaceCharacterSet()
    private let newLineCharacterSet = NSCharacterSet.newlineCharacterSet()
    private let letterCharacterSet = NSCharacterSet.letterCharacterSet()
    private let alphanumericCharacterSet = NSCharacterSet.alphanumericCharacterSet()
    
    // to be deprecated
    private let dynamicMarkingsString = "ompf"
    
    // to be deprecated
    private let articulationMarkingsString = "-.>"
    private var instrumentTypeCharacterSet: NSCharacterSet {
        return makeInstrumentTypeCharacterSet()
    }
    
    // MARK: - Lines of text
    
    // All lines in the file
    private var lines: LineCollection = LineCollection()
    
    // Current line count
    private var lineCount: Int = 0
    
    // Index of the first character of the current line
    private var lineStartIndex: Int = 0
    
    // MARK: Indentation
    
    // Indentation of each line in the file
    private var indentationLevelByLine: [Int] = []
    
    // Current indentation level
    private var currentIndentationLevel: Int { return indentationLevelByLine[lineCount] }
    
    // MARK: Current Location
    
    // Index of current character in the source file
    private var index: Int = 0
    
    // If current index is within a block comment
    private var isInBlockComment: Bool = false
    
    /// Top Level Commands (currently, only default, but may be user-extendable)
    public var topLevelCommands: [TopLevelCommand] = []
    
    /**
    Create a DNMTokenizer

    - returns: DNMTokenizer
    */
    public init() {
        setDefaultTopLevelCommands()
    }
    
    /**
    Create a TokenContainer for a given string (e.g., an entire file of DNMShorthand format)

    - parameter string: String of DNMShorthand code of any length

    - returns: TokenContainer
    */
    public func tokenizeString(string: String) -> TokenContainer {
        let mainScanner = makeMainScannerWith(string)
        let rootTokenContainer = makeRootTokenContainer()
        tokenizeWith(mainScanner, intoTokenContainer: rootTokenContainer)
        return rootTokenContainer
    }
    
    private func makeMainScannerWith(string: String) -> NSScanner {
        let scanner = NSScanner(string: string)
        scanner.charactersToBeSkipped = nil
        return scanner
    }
    
    private func makeRootTokenContainer() -> TokenContainer {
        return TokenContainer(identifier: "root", startIndex: 0)
    }
    
    private func tokenizeWith(scanner: NSScanner,
        intoTokenContainer rootTokenContainer: TokenContainer
    )
    {
        var lineStr: NSString?
        while !scanner.atEnd {
            if scanner.scanCharactersFromSet(newLineCharacterSet, intoString: &lineStr) {
                manageNewLineWith(lineStr!)
            } else {
                manageLineWith(scanner, andString: lineStr, intoContainer: rootTokenContainer)
            }
        }
    }


    private func manageLineWith(scanner: NSScanner,
        var andString string: NSString?,
        intoContainer container: TokenContainer
    )
    {
        while scanner.scanUpToCharactersFromSet(newLineCharacterSet,
            intoString: &string
        )
        {
            let lineLength = string!.length
            let lineScanner = makeLineScannerFor(string)
            incrementIndentationByLineWith(string)
            
            scanCommentsWithScanner(lineScanner, andContainer: container)
            guard !shouldContinueIfInBlockCommentWith(scanner) else { continue }
            
            scanPerformerDeclaractionWithScanner(lineScanner, andContainer: container)
            scanLineWithScanner(lineScanner, andContainer: container)
            incrementLineCountersFor(lineLength)
        }
    }
    
    private func makeLineScannerFor(string: NSString?) -> NSScanner {
        let lineScanner = NSScanner(string: string as! String)
        let skipSet = NSMutableCharacterSet(charactersInString: "_")
        skipSet.formUnionWithCharacterSet(NSCharacterSet.whitespaceCharacterSet())
        lineScanner.charactersToBeSkipped = skipSet
        lineScanner.caseSensitive = true
        return lineScanner
    }
    
    private func shouldContinueIfInBlockCommentWith(scanner: NSScanner) -> Bool {
        if isInBlockComment {
            lineStartIndex += scanner.string.characters.count
            return true
        }
        return false
    }
    
    private func incrementLineCountersFor(lineLength: Int) {
        lineStartIndex += lineLength
        lineCount++
    }
    
    private func incrementIndentationByLineWith(string: NSString?) {
        guard let string = string as? String else { return }
        let indentationLevel = indentationLevelWithLine(string)
        indentationLevelByLine.append(indentationLevel)
    }
    
    private func manageNewLineWith(string: NSString) {
        lineCount++
        lineStartIndex += string.length
        indentationLevelByLine.append(0)
    }
    
    // scan a single line with an inherited scanner and container
    private func scanLineWithScanner(scanner: NSScanner,
        andContainer container: TokenContainer
    )
    {
        scanHeaderWithScanner(scanner, andContainer: container)
        scanLeafDurationWithScanner(scanner, andContainer: container)
        scanTopLevelCommandsWithScanner(scanner, andContainer: container)
        
        // duration is currently just being fed to rootDurationNode, but should be made flexible
        scanDurationWithScanner(scanner, andContainer: container)
        scanPerformerIDAndInstrumentIDWithScanner(scanner, andContainer: container)
    }
    
    // attempt to scan top level commands in a single line string
    private func scanTopLevelCommandsWithScanner(scanner: NSScanner,
        andContainer container: TokenContainer
    )
    {
        // the index that the scanner is unwound back to
        // in the case of a match, this is set to index just after the stopIndex of the match
        var unwindIndex: Int = scanner.scanLocation
        
        while !scanner.atEnd {
            var matchWasFound = false
            for command in topLevelCommands {
                if scanTopLevelCommand(command, withScanner: scanner, andContainer: container) {
                    matchWasFound = true
                    unwindIndex = scanner.scanLocation
                    break
                }
            }
            if scanner.atEnd { break }
            if !matchWasFound && !scanner.atEnd { scanner.scanLocation++ }
        }
        scanner.scanLocation = unwindIndex
    }
    
    // TODO: Refactor into own class: CommandScanner
    private func scanTopLevelCommand(command: TopLevelCommand,
        withScanner scanner: NSScanner, andContainer parentContainer: TokenContainer
    ) -> Bool
    {
        var startIndex: Int = lineStartIndex + scanner.scanLocation
        
        // preventing commands that are the first characters of a line to crash
        if scanner.scanLocation > 0 { startIndex += 1 }
        
        var str: NSString?
        if scanner.scanString(command.openingValue, intoString: &str) {
            
            // index that the scanner is unwound back to
            var unwindIndex: Int = scanner.scanLocation
            
            // create TokenContainer for this top level command
            let container = makeTokenContainerForCommand(command, startingAtIndex: startIndex)
            
            // add the TokenContainer to the inherited parentContainer
            parentContainer.addToken(container)
            
            while !scanner.atEnd {
                var matchWasFound = false
                
                for type in command.allowableTypes {
                    if scanArgumentType(type, withScanner: scanner, andContainer: container) {
                        unwindIndex = scanner.scanLocation
                        matchWasFound = true
                    }
                    if scanner.atEnd { break }
                }
                if !matchWasFound && !scanner.atEnd {
                    scanner.scanLocation++
                    break
                } else {
                    
                }
            }
            scanner.scanLocation = unwindIndex
            return true
        }
        return false
    }
    
    // attempt to scan for all allowable argument types for a top level command
    private func scanArgumentType(argumentType: ArgumentType,
        withScanner scanner: NSScanner, andContainer container: TokenContainer
    ) -> Bool
    {
        func addToken(token: Token) { container.addToken(token) }
        
        func addStringValueTokenWithString(string: String, atIndex index: Int) {
            let token = TokenString(identifier: "Value", value: string, startIndex: index)
            addToken(token)
        }
        
        func addFloatValueTokenWithFloat(float: Float,
            fromIndex startIndex: Int, toIndex stopIndex: Int
        )
        {
            let token = TokenFloat(
                identifier: "Value",
                value: float,
                startIndex: startIndex,
                stopIndex: stopIndex
            )
            addToken(token)
        }
        
        // use polymorphism to select sublcass of ArgumentScanner
        
        // generalize the string ones
        let startIndex: Int = lineStartIndex + scanner.scanLocation
        switch argumentType {
        case .String:
            let tokenizer = ArgumentTokenizerString(scanner: scanner)
            if let token = try? tokenizer.makeToken() {
                container.addToken(token)
                return true
            }
        case .Float:
            var floatValue: Float = 0.0
            if scanner.scanFloat(&floatValue) {
                let stopIndex = lineStartIndex + scanner.scanLocation - 1
                addFloatValueTokenWithFloat(floatValue,
                    fromIndex: startIndex, toIndex: stopIndex
                )
                return true
            }
        case .DynamicMarking:
            let charSet = NSCharacterSet(charactersInString: dynamicMarkingsString)
            var str: NSString?
            if scanner.scanCharactersFromSet(charSet, intoString: &str) {
                addStringValueTokenWithString(str as! String, atIndex: startIndex + 1)
                return true
            }
        case .Articulation:
            let charSet = NSCharacterSet(charactersInString: articulationMarkingsString)
            var str: NSString?
            if scanner.scanCharactersFromSet(charSet, intoString: &str) {
                addStringValueTokenWithString(str as! String, atIndex: startIndex + 1)
                return true
            }
        case .Spanner:
            if scanSpannerStartWithScanner(scanner, andContainer: container) { return true }
        case .Int:
            // This is currently taken care of with Float
            break
        case .Duration:
            // This is currently done with a specific method scanDuration...()
            break
        case .PitchString:
            //let startIndex = scanner.scanLocation
            scanner.scanLocation++

            if let result = PitchParser().parseWith(scanner) as? Float {
                let stopIndex = lineStartIndex + scanner.scanLocation - 1
                addFloatValueTokenWithFloat(result,
                    fromIndex: startIndex, toIndex: stopIndex
                )
            } else {
                scanner.scanLocation = startIndex
            }
        }
        return false
    }
    
    private func makeTokenContainerForCommand(command: TopLevelCommand,
        startingAtIndex startIndex: Int
    ) -> TokenContainer
    {
        let tokenContainer = TokenContainer(
            identifier: command.identifier,
            openingValue: command.openingValue,
            startIndex: startIndex
        )
        return tokenContainer
    }
    
    // TODO: manage start index
    private func scanHeaderWithScanner(scanner: NSScanner,
        andContainer container: TokenContainer
    )
    {
        var key: String?
        var value: String?
 
        let startIndex = scanner.scanLocation + lineStartIndex + 1
        if scanner.string.characters.contains(Character(":")) {

            // get key
            var str: NSString?
            if scanner.scanUpToString(":", intoString: &str) {
                key = str as? String
                
                // brush past the ":"
                scanner.scanLocation++
                
                // set startIndex here
                // get value
                let set = NSCharacterSet.newlineCharacterSet()
                scanner.scanUpToCharactersFromSet(set, intoString: &str)
                value = str as? String
            }
        }
        
        // if key and value are valid, add tokens
        if let key = key, value = value {
            let keyToken = TokenString(
                identifier: "MetadataKey", value: key, startIndex: startIndex
            )
            let valueToken = TokenString(
                identifier: "MetadataValue", value: value, startIndex: startIndex
            )
            container.addToken(keyToken)
            container.addToken(valueToken)
        }
    }
    
    private func scanPerformerDeclaractionWithScanner(scanner: NSScanner,
        andContainer container: TokenContainer
        ) -> OrderedDictionary<String, OrderedDictionary<String, String>>?
    {
        // Enum used to switch between InstrumentID and InstrumentType as they are declared
        enum InstrumentIDOrType {
            case ID
            case Type
            
            mutating func switchState() {
                switch self {
                case .ID: self = .Type
                case .Type: self = .ID
                }
            }
        }
        
        let startIndex = scanner.scanLocation + lineStartIndex + 1
        
        var string: NSString?
        if scanner.scanString("P:", intoString: &string) {
            
            let performerDeclarationTokenContainer = TokenContainer(
                identifier: "PerformerDeclaration",
                openingValue: "P:",
                startIndex: startIndex
            )
            
            var performerID: String
            
            // DO ALL OF THE ORDERED DICT STUFF IN PARSER!
            var instrumentIDsAndInstrumentTypeByPerformerID = OrderedDictionary<
                String, OrderedDictionary<String, String>
                >()
            
            let letterCharacterSet = NSMutableCharacterSet.letterCharacterSet()
            
            let startIndex = scanner.scanLocation + lineStartIndex + 1
            
            // Match PerformerID declaration
            if scanner.scanCharactersFromSet(letterCharacterSet, intoString: &string) {
                
                // This is the PerformerID
                performerID = string as! String
                
                let performerIDToken = TokenString(
                    identifier: "PerformerID",
                    value: performerID,
                    startIndex: startIndex
                )
                
                performerDeclarationTokenContainer.addToken(performerIDToken)
                
                instrumentIDsAndInstrumentTypeByPerformerID[performerID] = (
                    OrderedDictionary<String,String>()
                )
                
                var dictForPID = instrumentIDsAndInstrumentTypeByPerformerID[performerID]!
                
                var instrumentID: String!
                var instrumentType: String!
                
                // This enum alternates with each symbol found
                var instrumentIDOrType = InstrumentIDOrType.ID
                
                while true {
                    
                    let startIndex = scanner.scanLocation + lineStartIndex + 1
                    
                    if scanner.scanCharactersFromSet(instrumentTypeCharacterSet,
                        intoString: &string
                        )
                    {
                        
                        switch instrumentIDOrType {
                        case .ID:
                            instrumentID = string as! String
                            
                            // Create Token for InstrumentID
                            let instrumentIDToken = TokenString(
                                identifier: "InstrumentID",
                                value: instrumentID,
                                startIndex: startIndex// + lineStartIndex
                            )
                            
                            // Commit InstrumentID Token
                            performerDeclarationTokenContainer.addToken(instrumentIDToken)
                            
                            // Switch enum to .Type
                            instrumentIDOrType.switchState()
                            
                        case .Type:
                            instrumentType = string as! String
                            
                            // Create Token for InstrumentType
                            let instrumentTypeToken = TokenString(
                                identifier: "InstrumentType",
                                value: instrumentType,
                                startIndex: startIndex// + lineStartIndex
                            )
                            
                            // Commit InstrumentType Token
                            performerDeclarationTokenContainer.addToken(instrumentTypeToken)
                            
                            dictForPID[instrumentID] = instrumentType
                            
                            // Clear everything
                            instrumentID = nil
                            instrumentType = nil
                            
                            // Switch enum to .ID
                            instrumentIDOrType.switchState()
                        }
                    }
                    else {
                        
                        // Commit PerformerDeclaration TokenContainer to root TokenContainer
                        container.addToken(performerDeclarationTokenContainer)
                        return instrumentIDsAndInstrumentTypeByPerformerID
                    }
                }
            }
        }
        return nil
    }
    
    // Refactor to own class
    private func scanPerformerIDAndInstrumentIDWithScanner(scanner: NSScanner,
        andContainer container: TokenContainer
    )
    {
        
        // Enum used to switch between PerformerID and InstrumentID
        enum PIDOrIID {
            case PID
            case IID
            
            mutating func switchState() {
                switch self {
                case .PID: self = .IID
                case .IID: self = .PID
                }
            }
        }
        
        var startIndex = scanner.scanLocation + lineStartIndex + 1
        
        var identifier: String
        var id: String?
        var pIDOrIID = PIDOrIID.PID
        var isComplete: Bool = false
        var string: NSString?
        while scanner.scanCharactersFromSet(letterCharacterSet, intoString: &string) {
            
            switch pIDOrIID {
            case .PID:
                identifier = "PerformerID"
                id = string as? String
                pIDOrIID.switchState()
                
            case .IID:
                identifier = "InstrumentID"
                id = string as? String
                
                // Once a pair of PID and IID is found, break out of loop
                isComplete = true
            }
            
            let token = TokenString(
                identifier: identifier,
                value: id!,
                startIndex: startIndex
            )
            container.addToken(token)
            
            startIndex = scanner.scanLocation + lineStartIndex + 1
            if isComplete { break }
        }
    }
    
    // Refactor to own class
    private func scanSpannerStartWithScanner(scanner: NSScanner,
        andContainer container: TokenContainer
    ) -> Bool
    {
        
        let startIndex = scanner.scanLocation
        var string: NSString?
        
        // this does enforce order: refactor to achieve loop (as with top-level-commands)
        if scanner.scanString("]", intoString: &string) {
            
            let spannerTokenContainer = TokenContainer(
                identifier: "SpannerStop",
                openingValue: "]",
                startIndex: startIndex + lineStartIndex
            )
            container.addToken(spannerTokenContainer)
        }
        
        // order of commands is enforced
        if scanner.scanString("[", intoString: &string) {
            
            let spannerTokenContainer = TokenContainer(
                identifier: "SpannerStart",
                openingValue: "[",
                startIndex: startIndex + lineStartIndex
            )
            
            // scanExponent
            while scanner.scanString("^", intoString: &string) {
                
                // dangerous!
                let expStartIndex = scanner.scanLocation
                var floatValue: Float = 0.0
                if scanner.scanFloat(&floatValue) {
                    
                    // dangerous!
                    let startIndex = scanner.scanLocation
                    
                    // create tokenContainer for spanner exponent
                    let exponentTokenContainer = TokenContainer(
                        identifier: "SpannerExponent",
                        openingValue: "^",
                        startIndex: startIndex
                    )
                    
                    // create single token for argument
                    let token = TokenFloat(
                        identifier: "Value",
                        value: floatValue,
                        startIndex: expStartIndex + lineStartIndex,
                        stopIndex: scanner.scanLocation + lineStartIndex
                    )
                    
                    exponentTokenContainer.addToken(token)
                    spannerTokenContainer.addToken(exponentTokenContainer)
                }
            }
            
            // scanWidth
            while scanner.scanString("-w", intoString: &string) {
                var startIndex = scanner.scanLocation
                
                let widthTokenContainer = TokenContainer(
                    identifier: "SpannerWidth",
                    openingValue: "-w",
                    startIndex: startIndex + lineStartIndex
                )
                
                var floatValue: Float = 0.0
                
                while scanner.scanFloat(&floatValue) {
                    let token = TokenFloat(
                        identifier: "Value",
                        value: floatValue,
                        startIndex: startIndex + lineStartIndex,
                        stopIndex: scanner.scanLocation + lineStartIndex - 1
                    )
                    widthTokenContainer.addToken(token)
                    startIndex = scanner.scanLocation
                }
                spannerTokenContainer.addToken(widthTokenContainer)
            }
            
            // scanDashes
            while scanner.scanString("-d", intoString: &string) {
                var startIndex = scanner.scanLocation
                
                let dashesTokenContainer = TokenContainer(
                    identifier: "SpannerDashes",
                    openingValue: "-d",
                    startIndex: startIndex + lineStartIndex
                )
                
                var floatValue: Float = 0.0
                while scanner.scanFloat(&floatValue) {
                    
                    let token = TokenFloat(
                        identifier: "Value",
                        value: floatValue,
                        startIndex: startIndex + lineStartIndex,
                        stopIndex: scanner.scanLocation + lineStartIndex - 1
                    )
                    dashesTokenContainer.addToken(token)
                    startIndex = scanner.scanLocation
                }
                spannerTokenContainer.addToken(dashesTokenContainer)
            }
            
            container.addToken(spannerTokenContainer)
            
            // TODO: scan color, control points, etc.
            return true
        }
        return false
    }
    
    private func scanSpannerStopWithScanner(scanner: NSScanner,
        andContainer container: TokenContainer
    )
    {
        let startIndex = scanner.scanLocation
        var string: NSString?
        
        // order of commands is enforced
        while scanner.scanString("]", intoString: &string) {
            
            let token = TokenString(
                identifier: "SpannerStop",
                value: "]",
                startIndex: startIndex + lineStartIndex + 1
            )
            container.addToken(token)
        }
    }
    
    // TODO: refactor into own class
    private func indentationLevelWithLine(line: String) -> Int {
        let whitespaceScanner = NSScanner(string: line)
        whitespaceScanner.charactersToBeSkipped = nil
        var tabCount: Int = 0
        var spaceCount: Int = 0
        var string: NSString?
        while whitespaceScanner.scanString(" ", intoString: &string) { spaceCount++ }
        while whitespaceScanner.scanString("\t", intoString: &string) { tabCount++ }
        let indentationLevel = tabCount + (spaceCount / 4)
        return indentationLevel
    }
    
    private func scanLeafDurationWithScanner(scanner: NSScanner,
        andContainer container: TokenContainer
    )
    {
        let startIndex = scanner.scanLocation
        var floatValue: Float = 0.0
        if scanner.scanFloat(&floatValue) {
            let identifier = durationIdentifierWith(scanner)
            let token = TokenFloat(
                identifier: identifier,
                value: floatValue,
                startIndex: startIndex + lineStartIndex,
                stopIndex: scanner.scanLocation + lineStartIndex - 1,
                indentationLevel: currentIndentationLevel
            )
            container.addToken(token)
        } else {
            scanner.scanLocation = startIndex
        }
    }
    
    private func durationIdentifierWith(scanner: NSScanner) -> String {
        var str: NSString?
        if scanner.scanString("--", intoString: &str) { return "InternalNodeDuration" }
        else { return "LeafNodeDuration" }
    }
    
    private func scanDurationWithScanner(scanner: NSScanner,
        andContainer container: TokenContainer
    )
    {
        let startIndex = scanner.scanLocation
        if let duration = DurationParser().parseWith(scanner) as? Duration {
            let token = TokenDuration(
                identifier: "Duration",
                duration: duration,
                startIndex: startIndex + lineStartIndex,
                stopIndex: scanner.scanLocation + lineStartIndex - 1
            )
            container.addToken(token)
        }
    }
    
    private func scanCommentsWithScanner(scanner: NSScanner,
        andContainer container: TokenContainer
    )
    {
        scanLineCommentWithScanner(scanner, andContainer: container)
        scanBlockCommentStartWithScanner(scanner, andContainer: container)
        scanBlockCommentStopWithScanner(scanner, andContainer: container)
    }
    
    private func scanBlockCommentStartWithScanner(scanner: NSScanner,
        andContainer container: TokenContainer
    )
    {
        var string: NSString?
        let startIndex: Int = scanner.scanLocation
        if scanner.scanString("/*", intoString: &string) {
            
            let token = TokenBlockCommentStart(startIndex: startIndex)
            container.addToken(token)
            
            isInBlockComment = true
        }
    }
    
    private func scanBlockCommentStopWithScanner(scanner: NSScanner,
        andContainer container: TokenContainer
    )
    {
        var string: NSString?
        if scanner.scanString("*/", intoString: &string) { isInBlockComment = false }
    }
    
    private func scanLineCommentWithScanner(scanner: NSScanner,
        andContainer container: TokenContainer
    )
    {
        var string: NSString?
        if scanner.scanString("//", intoString: &string) {
            scanner.scanUpToCharactersFromSet(newLineCharacterSet, intoString: &string)
        }
    }
    
    private func makeInstrumentTypeCharacterSet() -> NSMutableCharacterSet {
        let underscoreCharSet = NSMutableCharacterSet(charactersInString: "_")
        let alphanumericCharSet = NSMutableCharacterSet.alphanumericCharacterSet()
        alphanumericCharSet.formUnionWithCharacterSet(underscoreCharSet)
        return alphanumericCharSet
    }
    
    private func setDefaultTopLevelCommands() {
        let tlcs = TopLevelCommands.sharedInstance
        for tlc in tlcs.arrayValue {
            
            // identifier of top level command: for token creation / syntax highlighting
            let identifier = tlc["identifier"].stringValue
            
            // the string value that opens the command (e.g. "p" or "d")
            let openingValue = tlc["openingValue"].stringValue
            
            // allowable types for this command -- may have 0 values
            var allowableTypes: [ArgumentType] = []
            if let allowables = tlc["allowableTypes"].array {
                for allowableTypeJSON in allowables {
                    let allowableTypeString = allowableTypeJSON.stringValue
                    if let argumentType = ArgumentType(rawValue: allowableTypeString) {
                        allowableTypes.append(argumentType)
                    }
                }
            }
            
            // create top level command proper
            let topLevelCommand = TopLevelCommand(
                identifier: identifier,
                openingValue: openingValue,
                allowableTypes: allowableTypes
            )
            
            // add top level command
            topLevelCommands.append(topLevelCommand)
        }
    }
    
    private func addLineWithString(string: String, startingAtIndex startIndex: Int) {
        lines.addLineWithString(string, startingAtIndex: startIndex)
    }
}

/*
/**
Create a float representing a MIDI value with a properly formatted string.
- Defaults: octave starting at middle-c (c4), natural
- Specify sharp: "#" or "s"
- Specify flat: "b"
- Specify quarterSharp: "q#", "qs"
- Specify quarterFlat: "qf"
- Specify eighthTones: "gup", "d_qf_down_7", etc
- Underscores are ignored, and helpful for visualization

For example:
- "c" or "C" = middleC
- "d#","ds","ds4","d_s_4" = midi value 63.0 ("d sharp" above middle c)
- "eqb5","e_qf_5" = midi value 75.5
- "eb_up" = midi value 63.25


- parameter string: String representation of Pitch

- returns: Float representation of Pitch if you didn't fuck up the formatting of the String.
*/
public func midiFloatWithString(string: String) -> Float? {
    return FloatToMIDIParser(string: string).getFloatValue()
}
*/