import QuartzCore

/**
Duration of time (currently metrical only), consisting of Beats and Subdivision
*/
class Duration: Printable {
    
    // MARK: Attributes
    
    /// Printable description of Duration
    var description: String { get { return "Duration: \(beats.amount)/\(subdivision.value)" } }
    
    /// Beats in Duration
    var beats = Beats()
    
    /// Subdivision of Duration
    var subdivision = Subdivision()
    
    /// Subdivision Level (amount of beams) of Duration
    var subdivisionLevel: Int = 0
    
    var quotient: Float { get { return Float(beats.amount) / Float(subdivision.value) } }

    // MARK: Create a Duration
    
    /**
    Create an empty Duration
    
    :returns: Self: Duration
    */
    init() {}
    
    /**
    Create a Duration with Beats and Subdivision
    
    :param: beats       Beats
    :param: subdivision Subdivision
    
    :returns: Self: Duration
    */
    init(beats: Beats, subdivision: Subdivision) {
        self.beats = beats
        self.subdivision = subdivision
    }
    
    /**
    Create a Duration with amount of Beats and value of Subdivision
    
    :param: amountBeats      Amount of Beats
    :param: subdivisionValue Value of Subdivision
    
    :returns: Self: Duration
    */
    init(_ amountBeats: Int, _ subdivisionValue: Int) {
        self.beats = Beats(amountBeats)
        self.subdivision = Subdivision(subdivisionValue)
    }
    
    // MARK: Incrementally build a Duration
    
    /**
    Set Duration with Beats and Subdivision
    
    :param: beats       Beats
    :param: subdivision Subdivision
    
    :returns: Self: Duration
    */
    func setBeats(beats: Beats, subdivision: Subdivision) -> Duration {
        self.beats = beats
        self.subdivision = subdivision
        setSubdivisionLevel()
        return self
    }
    
    /**
    Set Duration with amount of beats and value of subdivision
    
    :param: beats       amount of Beats
    :param: subdivision value of Subdivision
    
    :returns: Self: Duration
    */
    func setDuration(beats: Int, subdivision: Int) -> Duration {
        self.beats = Beats(beats)
        self.subdivision = Subdivision(subdivision)
        setSubdivisionLevel()
        return self
    }
    
    /**
    Set value of Subdivision
    
    :param: subdivision value of Subdivision: (8, 16, 32, 64, 128, etc.)
    
    :returns: Self: Duration
    */
    func setSubdivision(subdivision: Int) -> Duration {
        self.subdivision = Subdivision(subdivision)
        setSubdivisionLevel()
        return self
    }
    
    // MARK: Adjust a Duration
    
    /**
    Scale Duration to match Subdivision value
    
    :param: value Desired value of Subdivision: (8, 16, 32, 64, 128, etc.)
    
    :returns: Self: Duration
    */
    func scaleToSubdivisionValue(value: Int) -> Duration {
        var scale: Float = Float(value) / Float(subdivision.value)
        var newBeats: Int = Int(Float(beats.amount) * scale)
        setDuration(newBeats, subdivision: value)
        return self
    }
    
    /**
    Scale Duration to match Beats amount
    
    :param: amount Desired amount of Beats
    
    :returns: Self: Duration
    */
    func scaleToBeats(amount: Int) -> Duration {
        var scale: Float = Float(amount) / Float(beats.amount)
        var newSubd: Int = Int(Float(subdivision.value) * scale)
        setDuration(amount, subdivision: newSubd)
        return self
    }
    
    /**
    Reduce Duration by desired amount
    
    :param: divisor Amount to reduce
    
    :returns: Self: Duration
    */
    func reduceBy(divisor: Float) -> Duration {
        var newBeats = Int(Float(beats.amount) / divisor)
        var newSubd = Int(Float(subdivision.value) / divisor)
        setDuration(newBeats, subdivision: newSubd)
        return self
    }
    
    // MARK: Get graphical width
    
    /**
    Get graphical width of Duration
    
    :param: beatWidth Graphical width of a single 8th-note
    
    :returns: CGFloat: graphic width of Duration
    */
    func getGraphicalWidth(beatWidth: CGFloat) -> CGFloat {
        var w: CGFloat = beatWidth * 8 * (
            CGFloat(beats.amount) /
            CGFloat(subdivision.value)
        )
        return w
    }
    
    /**
    Get temporal length of Duration
    
    :param: beatDuration Temporal length of a single 8th-note
    
    :returns: Double: temporal length of Duration
    */
    func getTemporalLength(beatDuration: Double) -> Double {
        var l: Double = beatDuration * 8 * (
            Double(beats.amount) /
            Double(subdivision.value)
        )
        return l
    }
    
    private func setSubdivisionLevel() {
        var a: Float, b: Float
        if beats.amount % 7 == 0 { a = 7; b = 4 }
        else if beats.amount % 3 == 0 { a = 3; b = 2 }
        else { a = 2; b = 2 }
        subdivisionLevel = Int(
            Float(subdivision.level) - (log(Float(beats.amount)/a*b)/log(2))
        )
    }
}

func + (left: Duration, right: Duration) -> Duration {
    
    // make subdivisions equiv
    
    //
    
    // check against subdval of 0
    if left.subdivision.value > right.subdivision.value {
        left.scaleToSubdivisionValue(right.subdivision.value)
    }
    else if left.subdivision.value < right.subdivision.value {
        right.scaleToSubdivisionValue(left.subdivision.value)
    }
    return Duration(left.beats.amount + right.beats.amount, right.subdivision.value)
}

func += (inout left: Duration, right: Duration) {
    left = left + right
}

func - (left: Duration, right: Duration) -> Duration {
    if left.subdivision.value > right.subdivision.value {
        left.scaleToSubdivisionValue(right.subdivision.value)
    }
    else if left.subdivision.value < right.subdivision.value {
        right.scaleToSubdivisionValue(left.subdivision.value)
    }
    return Duration(left.beats.amount - right.beats.amount, right.subdivision.value)
}

func -= (inout left: Duration, right: Duration) {
    left = left - right
}

func < (left: Duration, right: Duration) -> Bool {
    return left.quotient < right.quotient
}

func > (left: Duration, right: Duration) -> Bool {
    return left.quotient > right.quotient
}

func >= (left: Duration, right: Duration) -> Bool {
    return left.quotient >= right.quotient
}

func <= (left: Duration, right: Duration) -> Bool {
    return left.quotient <= right.quotient
}

func == (left: Duration, right: Duration) -> Bool {
    return left.quotient == right.quotient
}

func != (left: Duration, right: Duration) -> Bool {
    return left.quotient != right.quotient
}