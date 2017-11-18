extension Dictionary: TypedKeyCompatible
{
    public
    func value<T>(for key: TypedKey<T>) throws -> T
    {
        if
            let keyName = key.name as? Key, // http://stackoverflow.com/q/33620191
            let value = self[keyName] as? T
        {
            return value
        }
        else
        {
            throw NoValue(keyName: key.name, valueType: T.self)
        }
    }
    
    public
    mutating
    func set<T>(value: T, for key: TypedKey<T>)
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
    func removeValue<T>(for key: TypedKey<T>) throws -> T
    {
        if
            let keyName = key.name as? Key,
            let result = self.removeValue(forKey: keyName) as? T
        {
            return result
        }
        else
        {
            throw NoValue(keyName: key.name, valueType: T.self)
        }
    }
}
