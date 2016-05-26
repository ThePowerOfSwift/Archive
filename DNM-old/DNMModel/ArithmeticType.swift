//
//  ArithmeticType.swift
//  DNMModel
//
//  Created by James Bean on 8/12/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

/**
 Interface for semi-generic arithmetic operations
 */
public protocol ArithmeticType: Comparable {
    
    /**
     Add two ArithmeticType values together
     
     - parameter lhs: Augend value
     - parameter rhs: Addend value
     
     - returns: Sum of two ArithmticType values
     */
    static func + (lhs: Self, rhs: Self) -> Self
    
    /**
     Subtract ArithmeticType value from another
     
     - parameter lhs: Minuend value
     - parameter rhs: Subtrahend value
     
     - returns: Differece of two ArithmeticType values
     */
    static func - (lhs: Self, rhs: Self) -> Self
    
    /**
     Multiple two ArithmeticType values together
     
     - parameter lhs: Multiplicand value
     - parameter rhs: Multiplier value
     
     - returns: Product of two ArithmeticType values
     */
    static func * (lhs: Self, rhs: Self) -> Self
    
    /**
     Divide ArithmeticType value from another
     
     - parameter lhs: Dividend value
     - parameter rhs: Divisor value
     
     - returns: Quotion of two ArithmeticType values
     */
    static func / (lhs: Self, rhs: Self) -> Self
    
    /**
     Find remainder after division of dividend and modulus
     
     - parameter lhs: Dividend value
     - parameter rhs: Modulus value
     
     - returns: Remainder value
     */
    static func modulo(lhs: Self, _ rhs: Self) -> Self
    
    /**
     Zero value
     
     - returns: Zero
     */
    static func zero() -> Self
    
    static func one() -> Self
    
    /**
     Check if this ArithmeticType value is even (divisible by two)
     
     - returns: If this value is even
     */
    func isEven() -> Bool
    
    /**
     Format an ArithmeticType value for string representation
     
     - parameter f: Format of string: see NSString(format:) definition
     
     - returns: String formatted as desired
     */
    func format(f: String) -> String
}

// MARK: - Conform Integer to ArithmeticType
extension Int: ArithmeticType {

    public static func zero() -> Int { return 0 }
    
    public static func one() -> Int { return 1 }
    
    public static func modulo(lhs: Int, _ rhs: Int) -> Int {
        let result = lhs % rhs
        return result < 0 ? result + rhs : result
    }

    public func isEven() -> Bool { return self % 2 == 0 }
    
    public func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}

// MARK: - Prime check
extension Int {
    
    public var isPrime: Bool {
        if self <= 1 { return false }
        if self <= 3 { return true }
        var i = 2
        while i * i <= self {
            if self % i == 0 { return false }
            i = i + 1
        }
        return true
    }
}

// MARK: - Conform Float to ArithmeticType
extension Float: ArithmeticType {
    
    public static func zero() -> Float { return 0.0 }
    
    public static func one() -> Float { return 1.0 }
    
    public static func modulo(lhs: Float, _ rhs: Float) -> Float {
        let result = lhs % rhs
        return result < 0 ? result + rhs : result
    }
    
    public func isEven() -> Bool { return self % 2 == 0 }
    
    public func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}

// MARK: - Conform Double to ArithmeticType
extension Double: ArithmeticType {

    public static func modulo(lhs: Double, _ rhs: Double) -> Double {
        let result = lhs % rhs
        return result < 0 ? result + rhs : result
    }
    
    public static func zero() -> Double { return 0.0 }
    
    public static func one() -> Double { return 1 }
    
    public func isEven() -> Bool { return self % 2 == 0 }
    
    public func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}

// MARK: - Array extensions for ArithmeticType Elements
extension Array where Element: ArithmeticType {
    
    /**
    Generic sum of elements in Array
    
    - returns: Sum of elements in Array
    */
    public func sum<T: ArithmeticType>() -> T {
        guard self.count > 0 else { return T.zero() }
        return self.map { $0 as! T }.reduce(T.zero(), combine: +)
    }
    
    /**
     Mean of values in Array
     
     - returns: Mean of values in Array
     */
    public func mean<T: ArithmeticType>() -> T {
        if self[0] is Int {
            let sumAsInt: Int = self.sum()
            let countAsInt: Int = self.count
            return (sumAsInt as! T) / (countAsInt as! T)
        }
        else if self[0] is Float {
            let sumAsFloat: Float = self.sum()
            let countAsFloat = Float(self.count)
            return (sumAsFloat as! T) / (countAsFloat as! T)
        }
        else if self[0] is Double {
            let sumAsDouble: Double = self.sum()
            let countAsDouble = Double(self.count)
            return (sumAsDouble) as! T / (countAsDouble as! T)
        }
        return T.zero()
    }
    
    /**
     Variance of values in Array.
     
     - returns: Variance of values in Array
     */
    public func variance<T: ArithmeticType>() -> T {
        let mean: T = self.mean()
        return self.map { ($0 as! T - mean) * ($0 as! T - mean) }.mean()
    }
    
    /**
     Evenness of values in Array
     
     - returns: Evenness of values in Array
     */
    public func evenness<T: ArithmeticType>() -> T {
        var amountEven: Float = 0
        var amountOdd: Float = 0
        for el in self {
            if el.isEven() { amountEven++ }
            else { amountOdd++ }
        }
        return T.zero()
    }
    
    /**
     Cumulative array of Values (e.g., [1,2,1] -> [(1, 0),(2, 1),(1, 3)])
     
     - returns: Cumulative array of Values in Array
     */
    public func cumulative<T: ArithmeticType>() -> [(value: T, position: T)] {
        let typedSelf: [T] = self.map { $0 as! T }
        var newSelf: [(value: T, position: T)] = []
        var cumulative: T = T.zero()
        for val in typedSelf {
            cumulative = cumulative + val
            let pair: (value: T, position: T) = (value: val, position: cumulative)
            newSelf.append(pair)
        }
        return newSelf
    }
    
    public func greatestCommonDivisor<T: ArithmeticType>() -> T? {
        guard let min: T = self.minElement() as? T else { return nil }
        return  self.map { gcd(min, $0 as! T) }.minElement()
    }
}

public func gcd<T: ArithmeticType>(a: T, _ b: T) -> T {
    if b == T.zero() { return a }
    if a > b { return gcd(a - b, b) }
    return gcd(a, b - a)
}

// TODO: make generic versions of these
public func DEGREES_TO_RADIANS(degrees: Float) -> Float {
    return degrees / 180.0 * Float(M_PI)
}

public func RADIANS_TO_DEGREES(radians: Float) -> Float {
    return radians * (180.0 / Float(M_PI))
}