import Foundation

class Tokenizer {
    
    // input
    var items: [Item] = []
    
    // output
    var tokens: [Token] = []
    
    // current indentation level
    var indentationLevel: Int = 0

    init(items: [Item]) {
        self.items = items
    }
    
    func getTokens() -> [Token] {
        var lineCount: Int = 0
        var index: Int = 0
        while index < items.count {
            let item: Item = items[index]
            switch item {
            case .NewLine:
                setIndentationLevelToZeroIfNecessary(index: &index)
                lineCount++
            case .Indent:
                indentationLevel = getIndentationLevel(&index)
            case .Character(let cargo):
                getCharacterBegunAtIndex(index: &index, cargo: cargo, lineCount: lineCount)
            default: break
            }
            index++
        }
        return tokens
    }
    
    func setIndentationLevelToZeroIfNecessary(inout #index: Int) {
        switch items[index + 1] {
        case .Indent: break
        default: indentationLevel = 0
        }
    }
    
    func getIndentationLevel(inout index: Int) -> Int {
        var level: Int = 0
        var peek: Int = 0
        while index + peek < items.count {
            let next: Item = items[index + peek]
            switch next {
            case .Indent:
                level++
                peek++
            default:
                index += peek - 1
                return level
            }
        }
        return level
    }
    
    func getCharacterBegunAtIndex(inout #index: Int, cargo: String, lineCount: Int) -> String {
        switch cargo {
        case "0"..."9": // number
            let number = getNumberBegunAtIndex(&index)
            let token = Token.Number(
                cargo: number,
                indentationLevel: indentationLevel,
                lineCount: lineCount
            )
            addToken(token)
        case ",": // delimiter
            let token = Token.Symbol(
                cargo: cargo,
                indentationLevel: indentationLevel,
                lineCount: lineCount
            )
            addToken(token)
        default: // all other symbols
            let symbol = getSymbolBegunAtIndex(&index)
            let token = Token.Symbol(
                cargo: symbol,
                indentationLevel: indentationLevel,
                lineCount: lineCount
            )
            addToken(token)
        }
        return ""
    }
    
    func addToken(token: Token) {
        tokens.append(token)
    }
    
    func getSymbolBegunAtIndex(inout index: Int) -> String {
        var symbolAsString: String = ""
        var peek: Int = 0
        while index + peek < items.count {
            let next: Item = items[index + peek]
            switch next {
            case .Character(let cargo):
                symbolAsString += cargo
                peek++
            case .Space:
                index += peek - 1
                return symbolAsString
            default:
                index += peek - 1
                return symbolAsString
            }
        }
        return symbolAsString
    }
    
    func getNumberBegunAtIndex(inout index: Int) -> String {
        var numberAsString: String = ""
        var peek: Int = 0
        while index + peek < items.count {
            let cur: Item = items[index + peek]
            switch cur {
            case .Character(let cargo):
                if isDigitOrDecimalPoint(cargo) {
                    numberAsString += cargo
                    peek++
                }
                else {
                    index += peek - 1
                    return numberAsString
                }
            default:
                index += peek - 1
                return numberAsString
            }
        }
        return ""
    }
    
    func isDigitOrDecimalPoint(string: String) -> Bool {
        switch string {
        case "0"..."9", ".": return true
        default: return false
        }
    }
}