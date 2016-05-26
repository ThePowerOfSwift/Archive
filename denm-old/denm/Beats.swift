/**
Beats
*/
class Beats {
    
    // MARK: Attributes
    
	/// Amount of Beats
	var amount: Int = 0
    
    // MARK: Create Beats
    
    /**
    Create empty Beats
    
    :returns: Self: Beats
    */
    init() {}
    
    /**
    Create Beats with amount
    
    :param: amount Amount of beats
    
    :returns: Self: Beats
    */
    init(_ amount: Int) {
        self.amount = amount
    }
    
    // MARK: Incrementally build Beats
    
    /**
    Set amount of beats
    
    :param: amount Amount of Beats
    
    :returns: Self: Beats
    */
    func setAmount(amount: Int) -> Beats {
        self.amount = amount
        return self
    }
}