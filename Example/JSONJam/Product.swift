//
//  Product.swift
//  JSONJam
//
//  Created by Matt Luedke on 7/18/15.
//  Copyright (c) 2015 Matt Luedke. All rights reserved.
//

import JSONJam

public class Product: JSONJam {
    
    public var dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    public var productDescription: String?
    public var tags: [String]?
    public var price: Double?
    public var creationDate: NSDate?
    public var transactionDates: [NSDate]?
    public var owner: User?
    public var buyers: [User]?
    public var detailURL: NSURL?
    public var photoURLs: [NSURL]?
    public var thingIDontWantSerialized: String?
    
    override public func propertyMap() {
        map("product_description", string: &productDescription)
        map("tags", stringArray: &tags)
        map("price", double: &price)
        map("creation_date", date: &creationDate, dateFormat: dateFormat)
        map("transaction_dates", dateArray: &transactionDates, dateFormat: dateFormat)
        map("owner", object: &owner)
        map("buyers", objectArray: &buyers)
        map("url", url: &detailURL)
        map("photos", urlArray: &photoURLs)
    }
}

