import XCTest

//@testable
import XCETypedKey

class Main: XCTestCase {
    
    func testAccessValues()
    {
        let val1 = 11
        let val2 = false
        let val3 = [1.3, 2.4, 3.5]
        let val4 = Date()
        let val5 = "Value number 5"
        
        let key1 = TypedKey<Int>("One")
        let key2 = TypedKey<Bool>("Two")
        let key3 = TypedKey<[Int]>("Three")
        // let key4 = TypedKey("WrongKey")
        let key5 = TypedKey<Bool>("WrongValueType")
        
        let dict: [String: Any] = [key1.name: val1,
                                   key2.name: val2,
                                   key3.name: val3,
                                   "Four": val4,
                                   key5.name: val5]
        
        XCTAssertEqual(val1, try? dict.value(for: key1))
        XCTAssertEqual(val2, try? dict.value(for: key2))
        
        // it's NOT equal, because
        // the key forces conversiont to Array<Int> when we access value,
        // while the original value is Array<Double>,
        // just keep in mind that the  key forces value type conversion,
        // it's made this way on purpose:
        // XCTAssertNotEqual(val3, dict.value(for: key3))
        
        // it's NOT equal, because
        // "key4" has wrong key name,
        // "val4" has been added to the dict with different key name
        // XCTAssertNotEqual(val4, dict.value(for: key4))
        
        // the below expression won't even compile,
        // because "key5" has been constructed with "defaultValue"
        // of type Bool, so inferred ValueType of the key
        // (and so return value of the "value..." function
        // is not compatible with "val5" type,
        // and it's made this way on purpose
        // XCTAssertNotEqual(val5, dict.value(for: key5))
        
        // NOTE: use "setValue..." function of "TypedKeyAccessible"
        // to avoid adding incompatible key-value pairs
        
    }
    
}
