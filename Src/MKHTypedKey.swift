//
//  MKHTypedKey.swift
//  MKHTypedKey
//
//  Created by Maxim Khatskevich on 3/26/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

public
struct TypedKey<ValueType>
{
    let name: String
    let defaultValue: ValueType
    
    init(name: String, defaultValue: ValueType)
    {
        self.name = name
        self.defaultValue = defaultValue
    }
}

//===

public
protocol TypedKeyAccessible
{
    func value<ValueType>(forKey key: TypedKey<ValueType>) -> ValueType
    
    mutating
    func setValue<ValueType>(value: ValueType, forKey key: TypedKey<ValueType>)
    
    mutating
    func removeValue<ValueType>(forKey key: TypedKey<ValueType>) -> ValueType?
}
