/**
MetronomePrototype: more discussion needed
*/
class MetronomePrototype {
    
    var prototype: [Int]
    var priority: Int?
    var syncopation: Float?
    
    init(prototype: [Int]) {
        self.prototype = prototype
    }
    
    func setPriority(priority: Int) -> MetronomePrototype {
        self.priority = priority
        return self
    }
    
    func setSyncopation(syncopation: Float) -> MetronomePrototype {
        self.syncopation = syncopation
        return self
    }
}