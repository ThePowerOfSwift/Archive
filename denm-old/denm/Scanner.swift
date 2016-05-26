import Foundation

class Scanner {
    
    // input
    var code: String = ""
    
    // output
    var items: [Item] = [Item.BOF]
    
    init(code: String) {
        self.code = code
    }
    
    func getItems() -> [Item] {
        var index: Int = 0
        while index < code.utf16Count {
            var item: String = code[index]
            switch item {
            case " ": isSpace(index: &index)
            case "\n": isNewLine(index: &index)
            default: isCharacter(index: &index, cargo: item)
            }
        }
        items.append(Item.EOF)
        return items
    }
    
    private func isNewLine(inout #index: Int) {
        items.append(Item.NewLine)
        index++
    }
    
    private func isCharacter(inout #index: Int, cargo: String) {
        items.append(Item.Character(cargo: cargo))
        index++
    }
    
    private func isSpace(inout #index: Int) {
        if code[index + 1] != " " {
            items.append(Item.Space)
            index++
        }
        else {
            isIndent(index: &index)
        }
    }
    
    private func isIndent(inout #index: Int) {
        var isIndent: Bool = true
        var peek: Int = 1
        while peek < 4 {
            if code[index + peek] != " " { isIndent = false; break }
            else { peek++ }
        }
        if isIndent {
            items.append(Item.Indent)
            index += 4
        }
        else {
            items.append(Item.Space)
            index += peek
        }
    }
}