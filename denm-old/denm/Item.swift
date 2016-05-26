enum Item {
    case BOF
    case EOF
    case NewLine
    case Indent
    case Space
    case Character(cargo: String)
}