enum Token {
    case Number(cargo: String, indentationLevel: Int, lineCount: Int)
    case Symbol(cargo: String, indentationLevel: Int, lineCount: Int)
}