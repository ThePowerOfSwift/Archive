//
//  DictionaryExtensions.swift
//  DNMModel
//
//  Created by James Bean on 12/10/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

public extension Dictionary {
    mutating func merge<K, V>(dictionary: [K: V]){
        for (k, v) in dictionary {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}

// Note: this uses a private API (_ArrayType). Not sure what that means...
// MARK: - Dictionariy<Key, []>
public extension Dictionary where Value: _ArrayType {
    
    /**
    Ensure that an array value exists for specified key. If no array value exists for the
    specified key, an empty array will be created and set as the value for the given key.

    - parameter key: Key for which to ensure an array value
    */
    mutating func ensureArrayValueFor(key: Key) {
        if self[key] == nil { self[key] = [] }
    }
    
    /**
    Safely append value to the array value for a given key

    - parameter value: Value to append
    - parameter key:   Key for Array to append to
    */
    mutating func safelyAppend(value: Value.Generator.Element,
        toArrayWithKey key: Key
    )
    {
        ensureArrayValueFor(key)
        self[key]!.append(value)
    }
    
    /**
     Safely append the contents of an array to the array value for a given key
     
     - parameter values: Array of values of which to append the contents to the array at key
     - parameter key:    Key for array to append to
     */
    mutating func safelyAppendContentsOf(values: Value, toArrayWithKey key: Key) {
        ensureArrayValueFor(key)
        self[key]!.appendContentsOf(values)
    }
}

// MARK: -  Dictionary<Key, [Equatable]>
public extension Dictionary where Value: _ArrayType, Value.Generator.Element: Equatable {
    
    /**
     Safely append value to the array value for a given key. If this value already exists in
     desired array, the new value will not be added.
     
     - parameter value: Value to append to array for a given key
     - parameter key:   Key for array to append to
     */
    mutating func safelyAndUniquelyAppend(value: Value.Generator.Element,
        toArrayWithKey key: Key
    )
    {
        ensureArrayValueFor(key)
        if self[key]!.contains(value) { return }
        self[key]!.append(value)
    }
}

// TODO: find cleaned types to use, this is unwieldy
// MARK: - [String: [Hashable: [Equatable]]]
public extension Dictionary where
    Key: StringLiteralConvertible,
    Value: DictionaryLiteralConvertible,
    Value.Key: Hashable,
    Value.Value: _ArrayType,
    Value.Value.Generator.Element: Equatable
{
    
    /**
    Ensure that a dictionary value exists for specified KeyPath

    - parameter keyPath: `KeyPath` of count >= 1
    */
    mutating func ensureDictionaryValueFor(keyPath: KeyPath) {
        guard keyPath.count >= 1 else { return }
        if self[keyPath.keys[0] as! Key] == nil { self[keyPath.keys[0] as! Key] = [:] }
    }

    /**
    Safely append a value to an array, which is a value for a given `KeyPath`

    - parameter value:   Value to append
    - parameter keyPath: `KeyPath` of array to append to
    */
    mutating func safelyAppend(value: Value.Value.Generator.Element,
        toArrayWithKeyPath keyPath: KeyPath
    )
    {
        ensureDictionaryValueFor(keyPath)
        var dictCopy = self[keyPath.keys[0] as! Key] as! Dictionary<Value.Key, Value.Value>
        dictCopy.ensureArrayValueFor(keyPath.keys[1] as! Value.Key)
        dictCopy[keyPath.keys[1] as! Value.Key]!.append(value)
        updateValue(dictCopy as! Value, forKey: keyPath.keys[0] as! Key)
    }
    
    /**
    Safely append value to the array value for a given `KeyPath`. If this value already exists in
    desired array, the new value will not be added.

    - parameter value:   Value to append
    - parameter keyPath: `KeyPath` of array to append to
    */
    mutating func safelyAndUniquelyAppend(value: Value.Value.Generator.Element,
        toArrayWithKeyPath keyPath: KeyPath
    )
    {
        // TODO: wrap up in method
        ensureDictionaryValueFor(keyPath)
        var dictCopy = self[keyPath.keys[0] as! Key] as! Dictionary<Value.Key, Value.Value>
        dictCopy.ensureArrayValueFor(keyPath.keys[1] as! Value.Key)
        // < wrap up ------------
        
        // check if value already exists
        if dictCopy[keyPath.keys[1] as! Value.Key]!.contains(value) { return }
        
        // TODO: wrap up in method
        dictCopy[keyPath.keys[1] as! Value.Key]!.append(value)
        updateValue(dictCopy as! Value, forKey: keyPath.keys[0] as! Key)
        // < wrap up ------------
    }
    
    /**
     Create a Dictionary that is a deep merge of this and a new Dictionary. Prevents duplicates.
     
     - parameter newDict: Dictionary with which to merge
     
     - returns: Dictionary resulting from merging this Dictionary with a given other
     */
    func mergeWith(newDict: Dictionary<Key,Value>) -> Dictionary<Key, Value> {
        var result = Dictionary<Key,Value>()
        
        // add values for self
        for k in self.keys {
            let subDict = self[k] as! Dictionary<Value.Key, Value.Value>
            for kk in subDict.keys {
                let subSubArray = subDict[kk]!
                for el in subSubArray {
                    let keyPath = KeyPath(k as! String, kk as! String)
                    result.safelyAndUniquelyAppend(el, toArrayWithKeyPath: keyPath)
                }
            }
        }
        
        // add values for new dict
        for (k, subDict) in newDict {
            for (kk, subSubArray) in subDict as! Dictionary<Value.Key, Value.Value> {
                for el in subSubArray {
                    let keyPath = KeyPath(k as! String, kk as! String)
                    result.safelyAndUniquelyAppend(el, toArrayWithKeyPath: keyPath)
                }
            }
        }
        
        return result
    }
}

// MARK: - [Key : [Hashable: [Any]]]
public extension Dictionary where
    Value: DictionaryLiteralConvertible,
    Value.Key: Hashable,
    Value.Value: _ArrayType
{
    
    /**
     Ensure that a Dictionary value exists for a specified key
     
     - parameter key: Key for dictionary
     */
    mutating func ensureDictionaryValueFor(key: Key) {
        if self[key] == nil { self[key] = [:] }
    }
}

public func + <K,V>(lhs: Dictionary<K,[V]>, rhs: Dictionary<K,[V]>) -> Dictionary<K,[V]> {
    var result = Dictionary<K,[V]>()
    for (key, values) in lhs {
        if result[key] == nil { result[key] = [] }
        result[key]!.appendContentsOf(values)
    }
    for (key, values) in rhs {
        if result[key] == nil { result[key] = [] }
        result[key]!.appendContentsOf(values)
    }
    return result
}

public func += <K,V>(lhs: Dictionary<K,[V]>, rhs: Dictionary<K,[V]>) -> Dictionary<K,[V]> {
    return lhs + rhs
}

public func + <K,V>(lhs: Dictionary<K,V>, rhs: Dictionary<K,V>) -> Dictionary<K,V> {
    var result = Dictionary<K,V>()
    for (key, value) in lhs { result[key] = value }
    for (key, value) in rhs { result[key] = value }
    return result
}

public func + <K,V: Equatable>(lhs: Dictionary<K,[V]>, rhs: Dictionary<K,[V]>)
    -> Dictionary<K,[V]>
{
    var result = Dictionary<K,[V]>()
    
    for (key, array) in lhs {
        if result[key] == nil { result[key] = [] }
        for el in array {
            if !result[key]!.contains(el) { result[key]!.append(el) }
        }
    }
    
    for (key, array) in rhs {
        if result[key] == nil { result[key] = [] }
        for el in array {
            if !result[key]!.contains(el) { result[key]!.append(el) }
        }
    }
    
    return result
}

// find way to make this recursive
public func == <T: Equatable, K1: Hashable, K2: Hashable>(lhs: [K1: [K2: T]], rhs: [K1: [K2: T]])
    -> Bool
{
    if lhs.count != rhs.count { return false }
    for (key, lhsub) in lhs {
        if let rhsub = rhs[key] { if lhsub != rhsub { return false } }
        else { return false }
    }
    return true
}