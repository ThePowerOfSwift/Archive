import Foundation

class Parser {
    
    /// Tokens for Parser to Parse
    var tokens: [Token] = []
    
    /// Actions from Tokens
    var actions: [Action] = []
    
    // Command keys
    private let commands: [String] = ["#","p","d","a","(",")", "*"]
    
    /**
    The Parser takes in Tokens and creates Actions (making Int-things Ints, and so forth)
    
    :param: tokens Tokens
    
    :returns: Self: Parser
    */
    init(tokens: [Token]) {
        self.tokens = tokens
    }
    
    /**
    Get Actions from Tokens
    
    :returns: Actions
    */
    func getActions() -> [Action] {
        var index: Int = 0
        while index < tokens.count {
            let token = tokens[index]
            switch token {
            case .Number: isNumber(index: &index); index++ // get duration for spanTree!
            case .Symbol: isSymbol(index: &index)
            default: index++
            }
        }
        return actions
    }
    
    private func isSymbol(inout #index: Int) {
        let symbol = tokens[index]
        switch symbol {
        case .Symbol(let cargo, let indentationLevel, let lineCount):
            switch cargo {
            case let value where contains(commands, value):
                switch value {
                
                case "#":
                    addMeasure()
                    index++
                
                case "p":
                    let arguments = getPitchArgumentsBegunAtIndex(&index)
                    addPitchWithArguments(arguments)
                
                case "d":
                    let nextToken = tokens[index + 1]
                    switch nextToken {
                    case .Symbol(let cargo, let indentationLevel, let lineCount):
                        addDynamicWithArgument(cargo)
                        index += 2
                    default:
                        index += 2
                        break
                    }
                
                case "a":
                    let nextToken = tokens[index + 1]
                    switch nextToken {
                    case .Symbol(let cargo, let indentationLevel, let lineCount):
                        addArticulationWithArgument(cargo)
                        index += 2
                    default:
                        index += 2
                        break
                    }
                    
                case "(":
                    addSlurStart()
                    index++
                
                case ")":
                    addSlurEnd()
                    index++
                
                case "*":
                    println("Parser: Rest")
                    addRest()
                    index++
                    
                default:
                    // throw error
                    index++
                    break
                }
            // perhaps throw an error here?
            default: index++; break
            }
        // perhaps throw an error here?
        default: index++; break
        }
    }
    
    

    private func getPitchArgumentsBegunAtIndex(inout index: Int) -> [String] {
        var arguments: [String] = []
        var initialLineCount: Int = 0
        var initialIndentationLevel: Int = 0
        var peek: Int = 1
        while index + peek < tokens.count {
            let token = tokens[index + peek]
            switch token {
            case .Number(let cargo, let indentationLevel, let lineCount):
                if peek == 1 { initialLineCount = lineCount }
                else if lineCount != initialLineCount {
                    index += peek
                    return arguments
                }
                arguments.append(cargo)
                peek++
            default:
                index += peek
                return arguments
            }
        }
        // perhaps in context like this, an error can be thrown?
        index += peek
        return arguments
    }
    

    private func isNumber(inout #index: Int) {
        let number = tokens[index]
        switch number {
        case .Number(let cargo, let indentationLevel, let lineCount):
            switch indentationLevel {
            case 0:
                let duration = getDurationBegunAtIndex(&index)
                addSpanTreeWithDuration(duration)
            default:
                let beats = cargo
                let nextToken = tokens[index + 1]
                switch nextToken {
                case .Symbol(let cargo, let _, let _):
                    switch cargo {
                    case "--":
                        addSpanContainerWithAmountBeats(beats, depth: indentationLevel - 1)
                    default:
                        addSpanLeafWithAmountBeats(beats, depth: indentationLevel - 1)
                    }
                default: break // throw error here
                }
            }
        default: break
        }
    }
    
    private func getDurationBegunAtIndex(inout index: Int) -> (String, String) {
        var beats: String?
        var subdivision: String?
        var peek: Int = 0
        while index + peek < tokens.count {
            let token = tokens[index + peek]
            switch token {
            case .Number(let cargo, let _, let _):
                if beats == nil { beats = cargo }
                else {
                    subdivision = cargo
                    index += 3
                    return (beats!, subdivision!)
                }
            default: break
            }
            peek++
        }
        index += 3
        return (beats!, subdivision!)
    }
    
    // Mark: Helper functions
    
    private func addMeasure() {
        actions.append(Action.Measure)
    }
    
    private func addSpanTreeWithDuration(duration: (String, String)) {
        let integerDuration = getIntegerDurationFromStringDuration(duration)
        actions.append(Action.SpanTree(duration: integerDuration))
    }
    
    private func addSpanContainerWithAmountBeats(amountBeats: String, depth: Int) {
        let beats = getIntFromString(amountBeats)
        actions.append(Action.SpanContainer(amountBeats: beats, depth: depth))
    }
    
    private func addSpanLeafWithAmountBeats(amountBeats: String, depth: Int) {
        let beats = getIntFromString(amountBeats)
        actions.append(Action.SpanLeaf(amountBeats: beats, depth: depth))
    }
    
    private func addPitchWithArguments(arguments: [String]) {
        var floatArgs: [Float] = []
        for argument in arguments {
            let floatArg = getFloatFromString(argument)
            floatArgs.append(floatArg)
        }
        actions.append(Action.Pitch(floatArgs))
    }
    
    private func addDynamicWithArgument(argument: String) {
        actions.append(Action.Dynamic(marking: argument))
    }
    
    private func addArticulationWithArgument(argument: String) {
        actions.append(Action.Articulation(marking: argument))
    }
    
    private func addSlurStart() {
        actions.append(Action.SlurStart)
    }
    
    private func addSlurEnd() {
        actions.append(Action.SlurEnd)
    }
    
    private func addRest() {
        actions.append(Action.Rest)
    }
    
    // Mark: Convert Strings to Insts as necessary
    
    private func getIntFromString(string: String) -> Int {
        let integer = (string as NSString).integerValue
        return integer
    }
    
    private func getFloatFromString(string: String) -> Float {
        let float = (string as NSString).floatValue
        return float
    }
    
    private func getIntegerDurationFromStringDuration(stringDuration: (String, String))
        -> (Int, Int)
    {
        let (beats, subdivision) = stringDuration
        let b = (beats as NSString).integerValue
        let s = (subdivision as NSString).integerValue
        return (b,s)
    }
    
    // need general purpose getArgumentsBegunAtIndex that works
    
    /*
    func getArgumentsAtIndex(inout #index: Int) -> [String] {
    println("get args at index")
    var arguments: [String] = []
    var peek: Int =  1
    while index + peek < tokens.count {
    let token = tokens[index + peek]
    switch token {
    /*
    case .Command:
    index += peek - 1
    return arguments
    */
    case .Number(let cargo, let i):
    println("get args at index: number: \(cargo)")
    arguments.append(cargo)
    peek++
    case .Symbol(let cargo, let i):
    println("get args at index: symbol: \(cargo)")
    arguments.append(cargo)
    peek++
    default: break
    }
    }
    return arguments
    }
    */
    
}