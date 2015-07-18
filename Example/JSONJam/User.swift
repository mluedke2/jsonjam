//
//  User.swift
//  JSONJam
//
//  Created by Matt Luedke on 7/18/15.
//  Copyright (c) 2015 Matt Luedke. All rights reserved.
//

import JSONJam

public class User: JSONJam {
    
    public var name: String?
    public var shoeSize: ShoeSize?
    
    override public func propertyMap() {
        map("name", string: &name)
        map("shoe_size", object: &shoeSize)
    }
}
