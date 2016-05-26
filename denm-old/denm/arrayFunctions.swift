import Foundation
import QuartzCore

func reduce(inout array: [Int]) -> Int {
    // find gcd
    var gcd: Int
    var x: Float = abs(Float(array[0]))
    for el in array {
        var y: Float = abs(Float(el))
        while (x > 0 && y > 0) { if x > y { x %= y } else { y %= x } }
        x += y
    }
    gcd = Int(x)
    
    // reduce all by gcd
    for i in 0..<array.count { array[i] = array[i] / gcd }
    return gcd
}

// SUM ========================================================================================
func getSum(array: [Int]) -> Int {
    var sum: Int = 0
    for i in array { sum += i }
    return sum
}

func getSum(array: [CGFloat]) -> CGFloat {
    var sum: CGFloat = 0.0
    for i in array { sum += i }
    return sum
}

func getSum(array: [Float]) -> Float {
    var sum: Float = 0.0
    for i in array { sum += i }
    return sum
}

func getSum(array: [Double]) -> Double {
    var sum: Double = 0.0
    for i in array { sum += i }
    return sum
}

// CUMULATIVE =================================================================================
func getCumulative(array: [Int]) -> [Int] {
    var cumulative: [Int] = [0]
    var c: Int = 0
    for i in array {
        c += i
        cumulative.append(c)
    }
    return cumulative
}

func getCumulative(array: [CGFloat]) -> [CGFloat] {
    var cumulative: [CGFloat] = [0.0]
    var c: CGFloat = 0.0
    for i in array {
        c += i
        cumulative.append(c)
    }
    return cumulative
}

func getCumulative(array: [Float]) -> [Float] {
    var cumulative: [Float] = [0.0]
    var c: Float = 0.0
    for i in array {
        c += i
        cumulative.append(c)
    }
    return cumulative
}

func getCumulative(array: [Double]) -> [Double] {
    var cumulative: [Double] = [0.0]
    var c: Double = 0.0
    for i in array {
        c += i
        cumulative.append(c)
    }
    return cumulative
}

// CLOSEST  ===================================================================================
func getClosest(array: [CGFloat], val: CGFloat) -> CGFloat {
    var cur: CGFloat = array[0]
    var diff: CGFloat = abs(val - cur)
    for i in array {
        var newDiff = abs(val - i)
        if newDiff < diff { diff = newDiff; cur = i }
    }
    return cur
}

func getClosest(array: [Float], val: Float) -> Float {
    var cur: Float = array[0]
    var diff: Float = abs(val - cur)
    for i in array {
        var newDiff = abs(val - i)
        if newDiff < diff { diff = newDiff; cur = i }
    }
    return cur
}

func getClosest(array: [Double], val: Double) -> Double {
    var cur: Double = array[0]
    var diff: Double = abs(val - cur)
    for i in array {
        var newDiff = abs(val - i)
        if newDiff < diff { diff = newDiff; cur = i }
    }
    return cur
}

extension Int {
    func format(f: String) -> String {
        return NSString(format: "%\(f)d", self)
    }
}

extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self)
    }
}

extension Array {
    mutating func removeObject<U: Equatable>(object: U) {
        var index: Int?
        for (idx, objectToCompare) in enumerate(self) {
            if let to = objectToCompare as? U { if object == to { index = idx } }
        }
        if index != nil { self.removeAtIndex(index!) }
    }
}


