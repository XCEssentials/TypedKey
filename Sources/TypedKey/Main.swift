public
struct TypedKey<Value>
{
    public
    let name: String
    
    public
    init(_ name: String)
    {
        self.name = name
    }
}

//===

public
protocol TPKError: Error { }

public
struct NoValue: TPKError
{
    let keyName: String
    let valueType: Any.Type
}

//===

public
protocol TypedKeyCompatible
{
    /**
     Throws if there is no value for given key in the storage.
     */
    func value<T>(for key: TypedKey<T>) throws -> T
    
    mutating
    func set<T>(value: T, for key: TypedKey<T>)
    
    /**
     Throws if there is no value for given key in the storage.
     */
    mutating
    func removeValue<T>(for key: TypedKey<T>) throws -> T
}

//===

public
extension TypedKeyCompatible
{
    func hasValue<Value>(for key: TypedKey<Value>) -> Bool
    {
        do
        {
            _ = try value(for: key)

            return true
        }
        catch
        {
            return false
        }
    }
}
