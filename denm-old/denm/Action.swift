enum Action {
    case Measure
    case SpanTree(duration: (Int, Int))
    case SpanContainer(amountBeats: Int, depth: Int)
    case SpanLeaf(amountBeats: Int, depth: Int)
    case Pitch([Float])
    case Dynamic(marking: String)
    case Articulation(marking: String)
    case SlurStart
    case SlurEnd
    case Rest
}