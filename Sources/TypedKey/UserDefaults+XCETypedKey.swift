import Foundation

//===

extension UserDefaults: TypedKeyAccessible
{
    public
    func value<ValueType>(forKey key: TypedKey<ValueType>) -> ValueType
    {
        var result = key.defaultValue
        
        //===
        
        // never be confused: http://stackoverflow.com/a/1062573
        
        if
            let value = self.object(forKey: key.name) as? ValueType
        {
            result = value
        }
        
        //===
        
        return result
    }
    
    public
    func setValue<ValueType>(_ value: ValueType, forKey key: TypedKey<ValueType>)
    {
        set(value, forKey: key.name)
    }
    
    public
    func removeValue<ValueType>(forKey key: TypedKey<ValueType>) -> ValueType?
    {
        let result = value(forKey: key)
        
        //===
        
        removeObject(forKey: key.name)
        
        //===
        
        return result
    }
}
