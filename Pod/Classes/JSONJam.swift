import JSONHelper

public class JSONJam: Deserializable {
    
    private var jsonData: JSONDictionary?
    private var parameters = JSONDictionary()
    
    public func propertyMap() {
        fatalError("must override this")
    }
    
    public func parameterize() -> JSONDictionary {
        propertyMap()
        return parameters
    }
    
    required public init(data: JSONDictionary) {
        jsonData = data
        propertyMap()
        jsonData = nil
    }
    
    public init() {
    }
    
    public func map(key: String, inout boolean: Bool?) {
        if let jsonData = jsonData {
            boolean <-- jsonData[key]
        } else {
            parameters[key] = boolean
        }
    }
    
    public func map(key: String, inout booleanArray: [Bool]?) {
        if let jsonData = jsonData {
            booleanArray <-- jsonData[key]
        } else {
            parameters[key] = booleanArray
        }
    }
    
    public func map(key: String, inout int: Int?) {
        if let jsonData = jsonData {
            int <-- jsonData[key]
        } else {
            parameters[key] = int
        }
    }
    
    public func map(key: String, inout intArray: [Int]?) {
        if let jsonData = jsonData {
            intArray <-- jsonData[key]
        } else {
            parameters[key] = intArray
        }
    }
    
    public func map(key: String, inout float: Float?) {
        if let jsonData = jsonData {
            float <-- jsonData[key]
        } else {
            parameters[key] = float
        }
    }
    
    public func map(key: String, inout floatArray: [Float]?) {
        if let jsonData = jsonData {
            floatArray <-- jsonData[key]
        } else {
            parameters[key] = floatArray
        }
    }
    
    public func map(key: String, inout double: Double?) {
        if let jsonData = jsonData {
            double <-- jsonData[key]
        } else {
            parameters[key] = double
        }
    }
    
    public func map(key: String, inout doubleArray: [Double]?) {
        if let jsonData = jsonData {
            doubleArray <-- jsonData[key]
        } else {
            parameters[key] = doubleArray
        }
    }
    
    public func map(key: String, inout string: String?) {
        if let jsonData = jsonData {
            string <-- jsonData[key]
        } else {
            parameters[key] = string
        }
    }
    
    public func map(key: String, inout stringArray: [String]?) {
        if let jsonData = jsonData {
            stringArray <-- jsonData[key]
        } else {
            parameters[key] = stringArray
        }
    }
    
    public func map(key: String, inout date: NSDate?, var dateFormat: String) {
        if let jsonData = jsonData {
            date <-- (jsonData[key], dateFormat)
        } else {
            if let date = date {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = dateFormat
                parameters[key] = dateFormatter.stringFromDate(date)
            }
        }
    }
    
    public func map(key: String, inout dateArray: [NSDate]?, var dateFormat: String) {
        if let jsonData = jsonData {
            dateArray <-- (jsonData[key], dateFormat)
        } else {
            if let dateArray = dateArray {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = dateFormat
                var parameterizedArray = [String]()
                for date in dateArray {
                    parameterizedArray.append(dateFormatter.stringFromDate(date))
                }
                self.parameters[key] = parameterizedArray
            }
        }
    }
    
    public func map(key: String, inout url: NSURL?) {
        if let jsonData = jsonData {
            url <-- jsonData[key]
        } else {
            parameters[key] = url?.absoluteString
        }
    }
    
    public func map(key: String, inout urlArray: [NSURL]?) {
        if let jsonData = jsonData {
            urlArray <-- jsonData[key]
        } else {
            if let urlArray = urlArray {
                var parameterizedArray = [String]()
                for url in urlArray {
                    if let urlString = url.absoluteString {
                        parameterizedArray.append(urlString)
                    }
                }
                self.parameters[key] = parameterizedArray
            }
        }
    }
    
    public func map<T:JSONJam>(key: String, inout object: T?) {
        if let jsonData = jsonData {
            if let data = convertToNilIfNull(jsonData[key]) as? JSONDictionary {
                object = T(data: data)
            } else {
                object = nil
            }
        } else {
            if let object = object {
                self.parameters[key] = object.parameterize()
            }
        }
    }
    
    public func map<T:JSONJam>(key: String, inout objectArray: [T]?) {
        if let jsonData = jsonData {
            if let dataArray = convertToNilIfNull(jsonData[key]) as? [JSONDictionary] {
                objectArray = [T]()
                for data in dataArray {
                    objectArray!.append(T(data: data))
                }
            } else {
                objectArray = nil
            }
        } else {
            if let objectArray = objectArray {
                var parameterizedArray = [AnyObject]()
                for object in objectArray {
                    parameterizedArray.append(object.parameterize())
                }
                self.parameters[key] = parameterizedArray
            }
        }
    }
    
    public func map<T>(key: String, serializeClosure: (inout AnyObject?) -> Void, deserializeClosure: (T?) -> Void) {
        if let jsonData = jsonData {
            deserializeClosure(jsonData[key] as! T?)
        } else {
            serializeClosure(&self.parameters[key])
        }
    }
    
    private func convertToNilIfNull(object: AnyObject?) -> AnyObject? {
        if object is NSNull {
            return nil
        }
        return object
    }
}
