import UIKit
import XCTest
import JSONHelper
import JSONJam
import JSONJam_Example

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testSerializeAndDeserialize() {
        var randomProduct = self.createRandomProduct()
        
        var serializedProduct = randomProduct.parameterize()
        
        XCTAssertNotNil(serializedProduct, "serialized product can't be nil")
        
        var rebuiltProduct: Product?
        rebuiltProduct <-- (serializedProduct as AnyObject?)
        
        XCTAssertNotNil(rebuiltProduct, "rebuilt product can't be nil")
        
        if let rebuiltProduct = rebuiltProduct {
            
            XCTAssertNotNil(rebuiltProduct.productDescription, "product description can't be nil")
            if let productDescription = randomProduct.productDescription, rebuiltProductDescription = rebuiltProduct.productDescription {
                XCTAssertEqual(productDescription, rebuiltProductDescription, "product description must match")
            }
            
            XCTAssertNotNil(rebuiltProduct.tags, "tags can't be nil")
            if let tags = randomProduct.tags, rebuiltTags = rebuiltProduct.tags {
                XCTAssertEqual(tags, rebuiltTags, "tags must match")
            }
            
            XCTAssertNotNil(rebuiltProduct.price, "price can't be nil")
            if let price = randomProduct.price, rebuildPrice = rebuiltProduct.price {
                XCTAssertEqual(price, rebuildPrice, "price must match")
            }
            
            XCTAssertNotNil(rebuiltProduct.creationDate, "creationDate can't be nil")
            if let creationDate = randomProduct.creationDate, rebuiltCreationDate = rebuiltProduct.creationDate {
                XCTAssertEqualWithAccuracy(creationDate.timeIntervalSinceReferenceDate, rebuiltCreationDate.timeIntervalSinceReferenceDate, 1, "creationDate must match")
            }
            
            XCTAssertNotNil(rebuiltProduct.creationDate, "creationDate can't be nil")
            if let transactionDates = randomProduct.transactionDates, rebuiltTransactionDates = rebuiltProduct.transactionDates {
                for i in 0..<transactionDates.count {
                    XCTAssertEqualWithAccuracy(transactionDates[i].timeIntervalSinceReferenceDate, rebuiltTransactionDates[i].timeIntervalSinceReferenceDate, 1, "transactionDates must match")
                }
            }
            
            XCTAssertNotNil(rebuiltProduct.detailURL, "detailURL can't be nil")
            if let detailURL = randomProduct.detailURL, rebuildDetailURL = rebuiltProduct.detailURL {
                XCTAssertEqual(detailURL, rebuildDetailURL, "detailURL must match")
            }
            
            XCTAssertNotNil(rebuiltProduct.photoURLs, "photoURLs can't be nil")
            if let photoURLs = randomProduct.photoURLs, rebuildPhotoURLs = rebuiltProduct.photoURLs {
                XCTAssertEqual(photoURLs, rebuildPhotoURLs, "photoURLs must match")
            }
            
            XCTAssertNotNil(rebuiltProduct.owner, "owner can't be nil")
            if let owner = randomProduct.owner, rebuiltOwner = rebuiltProduct.owner {
                
                XCTAssertNotNil(rebuiltOwner.name, "owner name can't be nil")
                if let name = owner.name, rebuiltName = rebuiltOwner.name {
                    XCTAssertEqual(name, rebuiltName, "owner name must match")
                }
                
                XCTAssertNotNil(rebuiltOwner.shoeSize, "owner shoeSize can't be nil")
                if let shoeSize = owner.shoeSize, rebuiltShoeSize = rebuiltOwner.shoeSize {
                    
                    XCTAssertNotNil(rebuiltShoeSize.size, "shoeSize size can't be nil")
                    if let size = shoeSize.size, rebuiltSize = rebuiltShoeSize.size {
                        XCTAssertEqual(size, rebuiltSize, "shoeSize size must match")
                    }
                    
                    XCTAssertNotNil(rebuiltShoeSize.sizeSystem?.rawValue, "shoeSize sizeSystem can't be nil")
                    if let sizeSystem = shoeSize.sizeSystem, rebuiltSizeSystem = rebuiltShoeSize.sizeSystem {
                        XCTAssertEqual(sizeSystem, rebuiltSizeSystem, "shoeSize sizeSystem must match")
                    }
                }
            }
            
            
            XCTAssertEqual(randomProduct.buyers![0].shoeSize!.size!, rebuiltProduct.buyers![0].shoeSize!.size!, "first buyer's shoe size must match")
        }
    }
    
    func testDeserializeAndSerialize() {
        
        var jsonObject: JSONDictionary = ["product_description": "This is a wonderful thing.", "tags": ["imaginary", "terrific"], "price": 35.50, "creation_date": "1985-11-05 04:30:15", "transaction_dates": ["1987-05-03 04:15:30", "2005-09-20 08:45:52"], "owner": ["name": "Coleman Francis", "shoe_size": ["size": 9, "system": "AUS"]], "buyers": [["name": "Coleman Francis", "shoe_size": ["size": 9, "system": "AUS"]], ["name": "Mateo Mateo", "shoe_size": ["size": 8, "system": "UK"]]], "url": "http://www.mattluedke.com", "photos": ["http://www.mattluedke.com/wp-content/uploads/2013/08/cropped-IMG_2495.jpg", "http://www.mattluedke.com/wp-content/uploads/2013/08/cropped-IMG_24971.jpg"]]
        
        var deserializedProduct: Product?
        deserializedProduct <-- (jsonObject as AnyObject?)
        
        XCTAssertNotNil(deserializedProduct, "deserialized product can't be nil")
        
        var reserializedProduct = deserializedProduct?.parameterize()
        
        XCTAssertNotNil(reserializedProduct, "reserialized product can't be nil")
        
        XCTAssertEqual(reserializedProduct!["product_description"] as! String, jsonObject["product_description"] as! String, "product description must match")
        
        XCTAssertEqual((reserializedProduct!["owner"] as! JSONDictionary)["name"] as! String, (jsonObject["owner"] as! JSONDictionary)["name"] as! String, "owner name must match")
        
        XCTAssertEqual(((reserializedProduct!["buyers"] as! [JSONDictionary])[0]["shoe_size"] as! JSONDictionary)["size"] as! Int, ((jsonObject["buyers"] as! [JSONDictionary])[0]["shoe_size"] as! JSONDictionary)["size"] as! Int, "first buyer's shoe size must match")
    }
    
    func createRandomShoeSize() -> ShoeSize {
        var shoeSize = ShoeSize()
        
        shoeSize.size = Int(arc4random_uniform(15))
        
        var randomNumber = Int(arc4random_uniform(4))
        switch randomNumber {
        case 0:
            shoeSize.sizeSystem = .UnitedStates
        case 1:
            shoeSize.sizeSystem = .Europe
        case 2:
            shoeSize.sizeSystem = .UnitedKingdom
        default:
            shoeSize.sizeSystem = .Australia
        }
        
        return shoeSize
    }
    
    func createRandomUser() -> User {
        var user = User()
        
        var randomNumber = Int(arc4random_uniform(2))
        switch randomNumber {
        case 0:
            user.name = "Mateo"
        default:
            user.name = "Matthias"
        }
        user.shoeSize = self.createRandomShoeSize()
        
        return user
    }
    
    func createRandomProduct() -> Product {
        var product = Product()
        
        var randomDescNumber = Int(arc4random_uniform(2))
        switch randomDescNumber {
        case 0:
            product.productDescription = "This item will change your life."
        default:
            product.productDescription = "This item is best enjoyed with green tea."
        }
        
        var randomTagNumber = Int(arc4random_uniform(2))
        switch randomTagNumber {
        case 0:
            product.tags = ["timid", "interstellar", "quiet"]
        default:
            product.tags = ["tempestuous", "populist"]
        }
        
        product.price = Double(arc4random_uniform(200))
        product.creationDate = NSDate()
        product.transactionDates = [NSDate(), NSDate()]
        product.owner = createRandomUser()
        product.buyers = [createRandomUser(), createRandomUser(), createRandomUser()]
        product.detailURL = NSURL(string: "http://mattluedke.com/")
        product.photoURLs = [NSURL(string: "http://www.mattluedke.com/wp-content/uploads/2013/08/cropped-IMG_2495.jpg")!, NSURL(string: "http://www.mattluedke.com/wp-content/uploads/2013/08/cropped-IMG_24971.jpg")!]
        
        return product
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
