enum SpanComponent {
    case SlurStart(pID: String, iID: String)
    case SlurEnd(pID: String, iID: String)
    case Rest(pID: String, iID: String)
    case Dynamic(pID: String, iID: String, marking: String)
    case Articulation(pID: String, iID: String, marking: String)
    case Pitch(pID: String, iID: String, pitches: [Float])
}