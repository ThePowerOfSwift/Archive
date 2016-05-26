import Darwin

/**
Subdivision
*/
class Subdivision {
    
    // MARK: Attributes
    
    /// Subdivision value: (8, 16, 32, 64, 128, etc.)
    var value: Int = 0
    
    /// Subdivision level: Amount of beams (1: 8, 2: 16, 3: 32, 4: 64)
    var level: Int = 0 // make getter
    
    // MARK: Create a Subdivision
    
    /**
    Create an empty Subdivision

    :returns: Self: Subdivision
    */
    init() {}
    
    /**
    Create Subdivision with value
    
    :param: value Subdivison value: (8, 16, 32, 64, 128, etc.)
    
    :returns: Self: Subdivision
    */
    init(_ value: Int) {
        self.value = value
        setLevel()
    }
    
    /**
    Create Subdivision with level
    
    :param: level Subdivision level
    
    :returns: Self: Subdivision
    */
    init(level: Int) {
        self.level = level
        self.value = Int(pow(2.0, (Double(level) + 2.0))) // make getter
    }
    
    // MARK: Incrementally build a Subdivision
    
    /**
    Set Subdivision value
    
    :param: value Subdivision value: (8, 16, 32, 64, 128, etc.)
    
    :returns: Self: Subdivision
    */
    func setValue(value: Int) -> Subdivision {
        self.value = value
        setLevel()
        return self
    }
    
    private func setLevel() {
        level = Int(log(Double(value))/log(2)) - 2
    }
}

// overload == < >

// add func matchTo(subdivision: Subdivision) ?