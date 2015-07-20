# JSONJam

Single-line JSON serialization and deserialization in Swift is my jam.

Depends on [JSONHelper](https://github.com/isair/JSONHelper) and designed for use with [Alamofire](https://github.com/Alamofire/Alamofire).

## Requirements

* iOS 8+
* Swift 1.2+

## Installation

JSONJam is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
platform :ios, '8.0'
use_frameworks!
pod "JSONJam", :git => 'https://github.com/mluedke2/jsonjam.git'
```

## Usage

### Defining the model class

In your Swift model class:

* Import and subclass `JSONJam`
* Define your model's attributes
* Override `propertyMap()` and map your JSON keys to the relevant parameter (pass the parameter as a reference)

Example:

```swift
import JSONJam

public class User: JSONJam {

    public var name: String?
    public var favoriteNumber: Int?

    override public func propertyMap() {
        map("name", string: &name)
        map("favorite_number", int: &favoriteNumber)
    }
}
```

### Serialization

You can prepare your custom objects to be passed as a JSON like this:

```swift
// singular
customObject.parameterize()

// plural
customObjects.parameterize()
```

An example in Alamofire:

```swift
Alamofire.request(.POST, baseURL + "/customObjects", parameters: customObject.parameterize(), encoding: .JSON)
```

### Deserialization

You can turn JSON objects and arrays into your custom objects like this:

```swift
// singular
var customObject: CustomObject?
customObject <-- JSON

// plural
var customObjects: [CustomObject]?
customObjects <-- JSON
```

An Alamofire example (within a sample networking controller):

```swift
func getCustomObjects(success:([CustomObject]) -> Void, fail:NetworkError) -> Void {
        Alamofire.request(.GET, baseURL + "/customObjects")
            .responseJSON {(request, response, JSON, error) in
                switch error {
                case .Some(let error):
                    fail(error)
                case .None:
                    var customObjects: [CustomObject]?
                    customObjects <-- JSON
                    if let customObjects = customObjects {
                        success(customObjects)
                    } else {
                        // JSON parsing error
                    }
                }
        }
    }
```

## Example Project

To run the example project, clone the repo, and run `pod install` in the `Example` directory. It comes with tests! :]

## Extras

### Date Formats

Supply a date format string along with your `NSDate` (or arrays thereof), and it will be used in serialization/deserialization:

```swift
import JSONJam

class MyObject: JSONJam {

    var dateFormat = "yyyy-MM-dd HH:mm:ss"

    var creationDate: NSDate?
    var transactionDates: [NSDate]?

    override func propertyMap() {
        map("creation_date", date: &creationDate, dateFormat: dateFormat)
        map("transaction_dates", dateArray: &transactionDates, dateFormat: dateFormat)
    }
}
```

### Overriding serialization and deserialization

You can override the serialization/deserialization for a specific parameter and provide closures to do the job yourself.

This is useful in the case of enums, like in `ShoeSize` in the Example Project:

```swift
import JSONJam

class ShoeSize: JSONJam {

    enum SizeSystem: String {
        case UnitedStates = "US"
        case Europe = "EUR"
        case UnitedKingdom = "UK"
        case Australia = "AUS"
    }

    var size: Int?
    var sizeSystem: SizeSystem?

    override func propertyMap() {
        map("size", int: &size)
        map("system",
            serializeClosure:{ (inout outgoingParameter: AnyObject?) -> Void in
                outgoingParameter = self.sizeSystem?.rawValue as AnyObject?
            },
            deserializeClosure: { (data: String?) -> Void in
                if let data = data {
                    self.sizeSystem = SizeSystem(rawValue: data)
                }
            }
        )
    }
}
```

## Author

mluedke2, mluedke2@gmail.com

## License

JSONJam is available under the MIT license. See the LICENSE file for more info.
