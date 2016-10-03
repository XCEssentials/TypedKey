//
//  Dictionary+MKHTypedKey.swift
//  MKHTypedKey
//
//  Created by Maxim Khatskevich on 3/26/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

extension Dictionary: TypedKeyAccessible
{
    public
    func value<ValueType>(forKey key: TypedKey<ValueType>) -> ValueType
    {
        var result = key.defaultValue
        
        //===
        
        if
            let keyName = key.name as? Key, // http://stackoverflow.com/q/33620191
            let value = self[keyName] as? ValueType
        {
            result = value
        }
        
        //===
        
        return result
    }
    
    public
    mutating
    func setValue<ValueType>(_ value: ValueType, forKey key: TypedKey<ValueType>)
    {
        if
            let keyName = key.name as? Key,
            let newValue = value as? Value // make sure it's convertable
        {
            self[keyName] = newValue
        }
    }
    
    public
    mutating
    func removeValue<ValueType>(forKey key: TypedKey<ValueType>) -> ValueType?
    {
        var result: ValueType? = nil
        
        //===
        
        if
            let keyName = key.name as? Key
        {
            result = self.removeValue(forKey: keyName) as? ValueType
        }
        
        //===
        
        return result
    }
}
