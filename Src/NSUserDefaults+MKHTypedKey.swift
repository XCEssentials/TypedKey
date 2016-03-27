//
//  NSUserDefaults+MKHTypedKey.swift
//  MKHTypedKey
//
//  Created by Maxim Khatskevich on 3/27/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

extension NSUserDefaults: TypedKeyAccessible
{
    public
    func value<ValueType>(forKey key: TypedKey<ValueType>) -> ValueType
    {
        var result = key.defaultValue
        
        //===
        
        // never be confused: http://stackoverflow.com/a/1062573
        
        if
            let value = self.objectForKey(key.name) as? ValueType
        {
            result = value
        }
        
        //===
        
        return result
    }
    
    public
    func setValue<ValueType>(value: ValueType, forKey key: TypedKey<ValueType>)
    {
        if
            let newValue = value as? AnyObject // make sure it's convertable
        {
            setObject(newValue, forKey: key.name)
        }
    }
    
    public
    func removeValue<ValueType>(forKey key: TypedKey<ValueType>) -> ValueType?
    {
        let result = value(forKey: key)
        
        //===
        
        removeObjectForKey(key.name)
        
        //===
        
        return result
    }
}
