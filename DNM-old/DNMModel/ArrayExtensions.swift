//
//  ArrayExtensions.swift
//  DNMModel
//
//  Created by James Bean on 8/12/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

public extension Array {
    
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
    
    /// Second element in an Array
    var second: Element? { return self[1] as Element }
    
    /// Second-to-last element in Array
    var penultimate: Element? { return self[self.count - 2] as Element }
    
    
    /**
     Check if Array contains object
     
     - parameter object: Object for which to check status as member of Array
     
     - returns: If Array contains object
     */
    func containsObject(object: AnyObject) -> Bool {
        if let _ = indexOfObject(object) { return true }
        return false
    }
    
    /**
     Get index of equatable value type in Array
     
     - parameter value: Value for index to be found
     
     - returns: Index of value, if present
     */
    func indexOf<T: Equatable>(value: T) -> Int? {
        for (index, el) in self.enumerate() {
            if el as! T == value { return index }
        }
        return nil
    }
    
    /**
     Get index of object in Array
     
     - parameter object: Object for index to be found
     
     - returns: Index of object, if present
     */
    func indexOfObject(object: AnyObject) -> Int? {
        for (index, el) in self.enumerate() {
            if el as? AnyObject === object { return index }
        }
        return nil
    }
    
    /**
     Remove duplicate values from Array
     
     - returns: Array with no duplicate values
     */
    func unique<T: Equatable>() -> [T] {
        var buffer: [T] = []
        var added: [T] = []
        for el in self {
            if !added.contains(el as! T) {
                buffer.append(el as! T)
                added.append(el as! T)
            }
        }
        return buffer
    }
    
    /**
     Random element from Array
     
     - returns: Random element from Array
     */
    func random<T: Equatable>() -> T {
        let randomIndex: Int = Int(arc4random_uniform(UInt32(self.count)))
        return self[randomIndex] as! T
    }
    
    // MARK: - Replace elements in Array

    /**
    Replace element at index with a new element
    
    - parameter index:      Index of element to be replaced
    - parameter newElement: New element to replace element at index
    */
    mutating func replaceElementAt<T: Any>(index: Int, withElement newElement: T) {
        if index > 0 && index < self.count {
            removeAtIndex(index)
            insert(newElement as! Element, atIndex: index)
        }
    }
    
    /**
     Replace element with new element
     
     - parameter element:    Element to be replaced, if present in Array
     - parameter newElement: New element to replace given element
     */
    mutating func replace<T: Equatable>(element: T, withElement newElement: T) {
        if let index = indexOf(element) {
            removeAtIndex(index)
            insert(element as! Element, atIndex: index)
        }
    }
    
    /**
    Replace the last element in Array with a new element
    
    - parameter newElement: New element to replace last element
    */
    mutating func replaceLastWith<T: Any>(newElement: T) {
        if self.count > 0 {
            removeLast()
            append(newElement as! Element)
        }
    }
    
    /**
     Replace first element in Array with a new element
     
     - parameter newElement: New element to replace first element
     */
    mutating func replaceFirstWith<T: Any>(newElement: T) {
        if self.count > 0 {
            removeFirst()
            insert(newElement as! Element, atIndex: 0)
        }
    }
    
    // MARK: - Remove elements from Array
    
    /**
     Remove first element of Array
     */
    mutating func removeFirst() {
        guard count > 0 else { return }
        self.removeAtIndex(0)
    }
    
    /**
     Remove first number of elements from Array
     
     - parameter amount: Amount of elements to remove from beginning of Array
     */
    mutating func removeFirst(amount amount: Int) {
        guard count >= amount else { return }
        for _ in 0..<amount { self.removeAtIndex(0) }
    }
    
    /**
     Remove last number of elements from Array
     
     - parameter amount: Amount of elements to remove from end of Array
     */
    mutating func removeLast(amount amount: Int) {
        guard count >= amount else { return }
        for _ in 0..<amount { self.removeLast() }
    }
    
    /**
     Remove element from Array
     
     - parameter element: Element to remove
     */
    mutating func remove<T: Equatable>(element: T) {
        if let index = indexOf(element) { removeAtIndex(index) }
    }
    
    /**
     Remove object from Array
     
     - parameter object: Object to remove
     */
    mutating func removeObject(object: AnyObject) {
        let index: Int? = indexOfObject(object)
        if index != nil { removeAtIndex(index!) }
    }
}

/**
 Compare equality of two-tuples, containing two Equatable types
 
 - parameter tuple1: First tuple
 - parameter tuple2: Second tuple
 
 - returns: If tuples are equal
 */
public func ==<T: Equatable, U: Equatable> (tuple1:(T,U),tuple2:(T,U)) -> Bool {
    return (tuple1.0 == tuple2.0) && (tuple1.1 == tuple2.1)
}

/**
 Intersection of two arrays
 
 - parameter array0: First Array
 - parameter array1: Second Array
 
 - returns: Values shared by both Arrays
 */
public func intersection<T: Equatable>(array0: [T], array1: [T]) -> [T] {
    let intersection = array0.filter { array1.contains($0) }
    return intersection
}

/**
 Closed value in Array to target value
 
 - parameter array: Array of values to check
 - parameter val:   Target value
 
 - returns: Value in array closest to target value
 */
public func closest(array: [Float], val: Float) -> Float {
    var cur: Float = array[0]
    var diff: Float = abs(val - cur)
    for i in array {
        let newDiff = abs(val - i)
        if newDiff < diff { diff = newDiff; cur = i }
    }
    return cur
}

/**
 Get the closest power-of-two, with multiplier (m * 2 ^ n) to target value.
 // TODO: Make generic for ArithmeticType types
 
 - parameter multiplier: Multiplier of power-of-two (e.g., 3 * 2 ^ n)
 - parameter value:      Target value
 
 - returns: Closes power-of-two, with a given multiplier to a given target value
 */
public func closestPowerOfTwo(multiplier multiplier: Int, value: Int) -> Int {
    var potential: [Float] = []
    for exponent in -4..<4 {
        potential.append(Float(multiplier) * pow(2.0, Float(exponent)))
    }
    var closestVal: Float = closest(potential, val: Float(value))
    var newValue = value
    while closestVal % 1.0 != 0 { closestVal *= 2.0; newValue *= 2 }
    return Int(closestVal)
}

/*
Sort the contents of an array with contents of another array 
(e.g., make sure articulations are always stacked in the correct order)
*/
public func sorted<T: Equatable>(array: [T], withReferenceArray referenceArray: [T]) -> [T] {
    var result: [T] = []
    array.forEach {
        if result.count == 0 { result = [$0] }
        else {
            var shouldAppendElement = true
            if let referenceIndex = referenceArray.indexOf($0) {
                for i in 0..<result.count {
                    if i > referenceIndex {
                        result.insert($0, atIndex: i)
                        shouldAppendElement = false
                        break
                    }
                }
            }
            if shouldAppendElement { result.append($0) }
        }
    }
    return result
}

/*
Sort the contents of an array of Objects with contents of another array of Objects
(e.g., make sure articulations are always stacked in the correct order)
*/
public func sorted<T: AnyObject>(array: [T], withReferenceArray referenceArray: [T]) -> [T] {
    var result: [T] = []
    array.forEach {
        if result.count == 0 { result = [$0] }
        else {
            var shouldAppendElement = true
            if let referenceIndex = referenceArray.indexOfObject($0) {
                for i in 0..<result.count {
                    if i > referenceIndex {
                        result.insert($0, atIndex: i)
                        shouldAppendElement = false
                        break
                    }
                }
            }
            if shouldAppendElement { result.append($0) }
        }
    }
    return result
}