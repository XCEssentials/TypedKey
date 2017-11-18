import Foundation

//===

extension UserDefaults: TypedKeyCompatible
{
    public
    func value<T>(for key: TypedKey<T>) throws -> T
    {
        // never be confused: http://stackoverflow.com/a/1062573
        
        if
            let result = self.object(forKey: key.name) as? T
        {
            return result
        }
        else
        {
            throw NoValue(keyName: key.name, valueType: T.self)
        }
    }
    
    public
    func set<T>(value: T, for key: TypedKey<T>)
    {
        set(value, forKey: key.name)
    }
    
    public
    func removeValue<T>(for key: TypedKey<T>) throws -> T
    {
        let result = try value(for: key)
        
        //===
        
        removeObject(forKey: key.name)
        
        //===
        
        return result
    }
}
